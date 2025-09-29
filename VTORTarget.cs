
using System;
using Antmicro.Renode.Core;
using Antmicro.Renode.Core.Structure;
using Antmicro.Renode.Peripherals.Bus;
using Antmicro.Renode.Peripherals.CPU;

namespace Antmicro.Renode.Peripherals.Miscellaneous
{
    public class VTORTarget : IDoubleWordPeripheral
    {
        public VTORTarget (IMachine machine)
        {
            this.machine = machine;
        }

        public void Reset()
        {
        }

        public uint ReadDoubleWord(long offset)
        {
            CortexM.ContextState cpuInitiatorState = default;
            var sysbus = machine.GetSystemBus (this);
            bool contextAvailable = sysbus.TryGetCurrentContextState (out var cpuInitiator, out cpuInitiatorState);
            if (contextAvailable && cpuInitiatorState.Privileged == true && cpuInitiatorState.CpuSecure == true && cpuInitiatorState.AttributionSecure == true)
            {
                return offset == 0 ? /* sp= */ 0x20001000u : /* pc= */ 0x20000001u;
            }
            else
            {
                throw new Exception("Invalid attributes");
                return 0;
            }
        }

        public void WriteDoubleWord(long offset, uint value)
        {
        }

        private readonly IMachine machine;
    }
}
