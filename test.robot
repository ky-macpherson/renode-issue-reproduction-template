*** Variables ***
${SCRIPT_PATH}                      ${CURDIR}/test.resc

*** Keywords ***
Memory Should Be Equal To
    [Arguments]                     ${address}  ${value}
    ${res}=                         Execute Command  sysbus ReadDoubleWord ${address}
    Should Be Equal As Numbers      ${res}  ${value}

*** Test Cases ***
Should Perform Memory-To-Memory Transfer
    Execute Script                  ${SCRIPT_PATH}
    Start Emulation

    # Initialize memory
    Execute Command                 sysbus WriteDoubleWord 0x20001230 0x00000000

    # Signal dbg_test peripheral to begin the test
    Execute Command                 sysbus.dbg_test OnGPIO 1 True

    # Verify memory
    Memory Should Be Equal To       0x20001230  0x0b1e55ed
