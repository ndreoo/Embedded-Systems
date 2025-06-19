SECTIONS
{
  . = 0x80000000;													
  .text : {
		KEEP(*(.text._start));								
		*(.text*);														
	}
	. = ALIGN (CONSTANT (COMMONPAGESIZE));	
  .data : { 
		*(.data*)															
	}
}