
using System;

using Antmicro.Renode.Core;
using Antmicro.Renode.Core.Structure;
using Antmicro.Renode.Peripherals.Bus;

namespace Antmicro.Renode.Peripherals.Miscellaneous
{
    public class Repainter : IDoubleWordPeripheral, IKnownSize
    {
        public Repainter(IMachine machine, IBusPeripheral target)
        {
            this.machine = machine;
            this.target = target;
        }

        public void Reset()
        {
        }

        public uint ReadDoubleWord(long offset)
        {
            return 0;
        }

        public void WriteDoubleWord(long offset, uint value)
        {
            var sysbus = machine.GetSystemBus(this);
            sysbus.ChangePeripheralAccessCondition(target, "initiator == cpu1 && !attributionSecure", "initiator == cpu1 && attributionSecure");
        }
        public long Size => 0x4000;
        private readonly IMachine machine;
        private readonly IBusPeripheral target;
    }
}