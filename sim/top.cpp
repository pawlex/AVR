// DESCRIPTION: Verilator Main TB for AVR project
// DESCRIPTION: Connects to top.v
// DESCRIPTION: NCURSES UART Interface:
// "            tb_uart.tx -> AVR.UART.rx, AVR.UART.TX -> tb_uart.rx
// 
// auth: pawlex (github.com/pawlex)
// date: 20210104
//======================================================================

// Include common routines
#include <verilated.h>
#include <stdio.h>
#include <ncurses.h>

// Include model header, generated from Verilating "top.v"
#include "Vtop.h"

// If "verilator --trace" is used, include the tracing class
#if VM_TRACE
# include <verilated_vcd_c.h>
#endif

// USE NCURSES INTERFACE TO THE UART
// if defined, provides a "terminal" like interface to 
// the UART.  with Keypress and Console prints.
// if not defined, UART will continuously send 0x55 ('U')
// and use printf to print whatever it receives from the
// UART
#define USE_NCURSES

// Current simulation time (64-bit unsigned)
vluint64_t main_time = 0;
vluint64_t max_cycles = 0;
// Called by $time in Verilog
double sc_time_stamp() {
    return main_time;  // Note does conversion to real, to match SystemC
}

void toggle_clock(Vtop *top)
{
    top->hwclk = !top->hwclk;
    top->eval();
    top->hwclk = !top->hwclk;
    top->eval();
    main_time += 2;
}

int getArgValueStr(const char *flag, char **value)
// args:    flag : *(str)<+str>=<value>
//          value: *(str)<value>
// returns: 0 if split successful else 1
{
    #define ARG_VALUE_SZ 64
    char flag_c[ARG_VALUE_SZ];
    strncpy(flag_c,flag,ARG_VALUE_SZ);
    // toss the flag
    strtok(flag_c,"=");
    // write the value
    *value = strtok(NULL, "=");
    return (*value == NULL);
}

unsigned long getArgValueUL(const char *flag)
// does conversion of <STR> to <UL> from getArgValueStr()
{
    unsigned long intvalue;
    char *strvalue;
    if(0==getArgValueStr(flag, &strvalue))
    {
        char intstr[10]; strncpy(intstr,strvalue,10);
        intvalue = strtoul (intstr, &strvalue, 10);
        return intvalue;
    }

    return (unsigned long) NULL;
}

int main(int argc, char** argv, char** env) {
    
    
    Verilated::commandArgs(argc, argv);
    Vtop* top = new Vtop;  // Or use a const unique_ptr, or the VL_UNIQUE_PTR wrapper

#if VM_TRACE
// If verilator was invoked with --trace argument,
// and if at run time passed the +trace argument, turn on tracing
    VerilatedVcdC* tfp = NULL;

    const char* flag = Verilated::commandArgsPlusMatch("trace");

    if (flag && 0==strcmp(flag, "+trace")) {
        Verilated::traceEverOn(true);  // Verilator must compute traced signals
        VL_PRINTF("Enabling waves into logs/vlt_dump.vcd...\n");
        tfp = new VerilatedVcdC;
        top->trace(tfp, 99);  // Trace 99 levels of hierarchy
        Verilated::mkdir("logs");
        tfp->open("logs/vlt_dump.vcd");  // Open the dump file
    }
#endif

    // Grab the command line arg for +prescale=
    // 
    #define DEFAULT_TB_UART_PRESCALE 20
    unsigned long prescale = DEFAULT_TB_UART_PRESCALE;
    const char *psflag = Verilated::commandArgsPlusMatch("prescale");
    if (psflag && 0<=strcmp(psflag, "+prescale")) {
        prescale = getArgValueUL(psflag);
        prescale = (prescale) ? prescale : DEFAULT_TB_UART_PRESCALE;
        printf("TB UART prescale value: %lu\n", prescale);
    }
    top->uart_prescale = (prescale); // Testbench UART PRESCALE VALUE
    //
    // Grab command line arg for +max_sim_time=
    #define MAX_SIM_TIME 4000000
    unsigned long max_sim_time = MAX_SIM_TIME;
    const char *mstflag = Verilated::commandArgsPlusMatch("max_sim_time");
    if (mstflag && 0<=strcmp(mstflag, "+max_sim_time")) {
        max_sim_time = getArgValueUL(mstflag);
        // TODO: Fix conversion error vs. forever
        //max_sim_time = (max_sim_time) ? max_sim_time : MAX_SIM_TIME;
        printf("TB MAX SIM TIME value: %lu\n", max_sim_time);
    }
    //
    int myinput = 0;
    int row,col;
    #ifdef USE_NCURSES
    initscr();
    #endif
    noecho();
    cbreak();
    nodelay(stdscr, TRUE);
    //timeout(0);
    getmaxyx(stdscr,row,col);	
    scrollok(stdscr, TRUE);
    int myrow = 0;
    int mycol = 0;
    int keypress = ERR;
    //
    int rx_counter = 0;



    // Construct the Verilated model, from Vtop.h generated from Verilating "top.v"
    //Vtop* top = new Vtop;  // Or use a const unique_ptr, or the VL_UNIQUE_PTR wrapper

    // Prevent unused variable warnings
    if (0 && argc && argv && env) {}

    // Set debug level, 0 is off, 9 is highest presently used
    // May be overridden by commandArgs
    Verilated::debug(0);

    // Randomization reset policy
    // May be overridden by commandArgs
    Verilated::randReset(2);

    // Pass arguments so Verilated code can see them, e.g. $value$plusargs
    // This needs to be called before you create any model
    //Verilated::commandArgs(argc, argv);
    //foo = Verilated::commandArgs();


    // Simple reset logic
    top->rst = 1;
    top->hwclk = 0;
    toggle_clock(top);
    toggle_clock(top);
    toggle_clock(top);
    toggle_clock(top);
    top->rst = 0;


    //while (!Verilated::gotFinish()) {
    //    main_time++;
    //    top->hwclk = !top->hwclk;
    //    top->eval();
    //while (!Verilated::gotFinish() || (main_time > max_cycles) ) {
    while(main_time < max_sim_time || max_sim_time == 0) {
        // Handle the input first, because the lag gets nasty.
#ifdef USE_NCURSES
        keypress = getch();
#else
        keypress = 0x55;
#endif
        if(top->uart_tx_ready_o)
        {
            if(keypress != ERR)
            {
                top->uart_tx_data_i = keypress;
                top->uart_tx_valid_i = 1;
                toggle_clock(top);
                top->uart_tx_valid_i = 0;
                keypress = ERR;
            }
        } else {
            // Uart was busy so let's throw it back on the stack;
            ungetch(keypress);
        }


        if(rx_counter == 0)
        {
            top->uart_rx_ready_i = 0;

            // Write the UART output
            if(top->uart_rx_valid_o)
            {
                char mychar = (char) top->uart_rx_data_o;
#ifdef USE_NCURSES
                printw("%c", mychar);
                refresh();
#else
                printf("%c", mychar);
#endif
                top->uart_rx_ready_i = 1;
                rx_counter = 2;
            }

        } else {
            rx_counter--;
        }
        
        main_time++;
        top->hwclk = !top->hwclk;
        top->eval();


#if VM_TRACE
        // Dump trace data for this cycle
        if (tfp) tfp->dump(main_time);
#endif
    }

    // Final model cleanup
    top->final();
    printf("\r\n");
#ifdef USE_NCURSES
    endwin();
#endif

#if VM_TRACE
    if (tfp) { tfp->close(); tfp = NULL; }
#endif
    // Destroy model
    delete top; top = NULL;

    // Fin
    exit(0);
}
