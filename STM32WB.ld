/* STM32WB.ld - Linker script for STM32WB series Cortex-M4 microcontroller */

/* Entry Point */
ENTRY(Reset_Handler)

/* Define Memory Regions */
MEMORY
{
    FLASH (rx)      : ORIGIN = 0x08000000, LENGTH = 512K    /* Main program memory */
    RAM (xrw)       : ORIGIN = 0x20000000, LENGTH = 128K    /* SRAM */
}

/* Sections Definitions */
SECTIONS
{
    /* Vector Table */
    .isr_vector :
    {
        KEEP(*(.isr_vector))    /* Interrupt vector table */
    } > FLASH

    /* Code (Text) Section */
    .text :
    {
        *(.text*)                /* All .text code */
        *(.rodata*)              /* Read-only data */
        *(.glue_7) *(.glue_7t)   /* ARM exceptions glue code */
        KEEP(*(.init)) KEEP(*(.fini))
    } > FLASH

    /* Initialized Data Section */
    .data : AT (ADDR(.text) + SIZEOF(.text))
    {
        _sidata = LOADADDR(.data);   /* Source address in FLASH for .data */
        _sdata = .;                  /* Start of .data section in RAM */
        *(.data*)                    /* Initialized data */
        _edata = .;                  /* End of .data section */
    } > RAM

    /* Additional Memory Section (MB_MEM2) */
    .mb_mem2 : AT (ADDR(.data) + SIZEOF(.data))
    {
        _siMB_MEM2 = LOADADDR(.mb_mem2);  /* Source address in FLASH for .mb_mem2 */
        _sMB_MEM2 = .;                    /* Start of .mb_mem2 section in RAM */
        *(.mb_mem2*)                      /* Custom section data */
        _eMB_MEM2 = .;                    /* End of .mb_mem2 section */
    } > RAM

    /* Uninitialized Data (BSS) Section */
    .bss :
    {
        _sbss = .;               /* Start of .bss section */
        *(.bss*)                 /* Uninitialized data */
        *(COMMON)
        _ebss = .;               /* End of .bss section */
    } > RAM

    /* Stack and Heap */
    ._user_heap_stack (NOLOAD) :
    {
        PROVIDE(_sheap = .);
        . = . + _Min_Heap_Size;
        PROVIDE(_eheap = .);
        . = . + _Min_Stack_Size;
        PROVIDE(_estack = .);
    } > RAM

    /* Define End of RAM for System Memory */
    _end = .;
    _estack = ORIGIN(RAM) + LENGTH(RAM); /* Set stack pointer to end of RAM */
}

/* Provide Symbols for System Initialization */
PROVIDE(_stack = ORIGIN(RAM) + LENGTH(RAM));
PROVIDE(_Heap_Limit = _end);

/* Additional Symbols for Startup Code */
PROVIDE(__start = _sdata);
PROVIDE(__end = _edata);
PROVIDE(__bss_start__ = _sbss);
PROVIDE(__bss_end__ = _ebss);

_Min_Heap_Size = 0x200;
_Min_Stack_Size = 0x400;
