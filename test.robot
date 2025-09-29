*** Comments ***
Check the security attributes on the initial PC/SP reads issued by M33 on boot
    
*** Variables ***

${REPL_STRING}=  SEPARATOR=\n
...  """
...  sram: Memory.MappedMemory @ sysbus 0x20000000
...  ${SPACE*4}size: 0x80000
... 
...  nvic: IRQControllers.NVIC @ sysbus new Bus.BusPointRegistration {
...  ${SPACE*8}address: 0xE000E000;
...  ${SPACE*8}cpu: cpu
...  ${SPACE*4}}
...  ${SPACE*4}-> cpu@0
...  cpu: CPU.CortexM @ sysbus
...  ${SPACE*4}cpuType: "cortex-m33"
...  ${SPACE*4}nvic: nvic
...  ${SPACE*4}cpuId: 0
...  ${SPACE*4}enableTrustZone: true
... 
...  vtortarget: Miscellaneous.VTORTarget @ sysbus <0x0, +0x1000>
...  """

*** Test Cases ***
Boot Test
    Execute Command         mach create
    Execute Command         include @${CURDIR}/VTORTarget.cs
    Execute Command         machine LoadPlatformDescriptionFromString ${REPL_STRING}
    Execute Command         sysbus.cpu AssembleBlock 0x20000000 "wfi"
    Execute Command         sysbus.cpu VectorTableOffset 0x0
    Start Emulation
