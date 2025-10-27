*** Comments ***

*** Variables ***
${EUSART0_BASE_S}            0x40000000
${REPAINTER_BASE_S}          0x60000000

${REPL_STRING}=  SEPARATOR=\n
...  """
...  nvic0: IRQControllers.NVIC @ sysbus new Bus.BusPointRegistration {
...  ${SPACE*8}address: 0xE000E000;
...  ${SPACE*8}cpu: cpu0
...  ${SPACE*4}}
...  ${SPACE*4}-> cpu0@0
...  cpu0: CPU.CortexM @ sysbus
...  ${SPACE*4}cpuType: "cortex-m33"
...  ${SPACE*4}nvic: nvic0
...  ${SPACE*4}cpuId: 0
...  ${SPACE*4}enableTrustZone: true
...  ${SPACE*4}IsHalted: true
...
...  nvic1: IRQControllers.NVIC @ sysbus new Bus.BusPointRegistration {
...  ${SPACE*8}address: 0xE000E000;
...  ${SPACE*8}cpu: cpu1
...  ${SPACE*4}}
...  ${SPACE*4}-> cpu1@0
...  cpu1: CPU.CortexM @ sysbus
...  ${SPACE*4}cpuType: "cortex-m33"
...  ${SPACE*4}nvic: nvic1
...  ${SPACE*4}cpuId: 1
...  ${SPACE*4}enableTrustZone: true
...  ${SPACE*4}IsHalted: true
...
...  scratchpad: Python.PythonPeripheral @ {
...  ${SPACE*4}sysbus new Bus.BusRangeRegistration {
...  ${SPACE*8}range: <${EUSART0_BASE_S}, +0x4000>;
...  ${SPACE*8}condition: "initiator == cpu0 && attributionSecure"
...  ${SPACE*4}};
...  ${SPACE*4}sysbus new Bus.BusRangeRegistration {
...  ${SPACE*8}range: <${EUSART0_BASE_S}, +0x4000>;
...  ${SPACE*8}condition: "initiator == cpu1 && attributionSecure"
...  ${SPACE*4}}
...  }
...  ${SPACE*4}size: 0x4000
...  ${SPACE*4}initable: false
...  ${SPACE*4}script: "request.value = 0"
...
...  repainter: Miscellaneous.Repainter @ sysbus ${REPAINTER_BASE_S}
...  ${SPACE*4}target: scratchpad
...  """

*** Keywords ***

Create Machine
    Execute Command         mach create
    Execute Command         include @${CURDIR}/Repainter.cs
    Execute Command         machine LoadPlatformDescriptionFromString ${REPL_STRING}
    Execute Command         emulation SetGlobalSerialExecution true

*** Test Cases ***

Repaint
    Create Machine
    Execute Command         sysbus.repainter WriteDoubleWord 0x0 0x0
