using Microsoft.Win32;
using System;
using System.Management;
using System.Windows;
using System.Windows.Media;
using System.Threading;

namespace Z6FanControl
{

    public static class WMIEC
    {
        private static readonly WMIEC.Destructor finalObj = new WMIEC.Destructor();

        public static bool WMIReadECRAM(ulong Addr, ref object data)
        {
            try
            {
                ManagementObject managementObject = new ManagementObject("root\\WMI", "AcpiTest_MULong.InstanceName='ACPI\\PNP0C14\\1_1'", (ObjectGetOptions)null);
                ManagementBaseObject methodParameters = managementObject.GetMethodParameters("GetSetULong");
                Addr = 1099511627776UL + Addr;
                methodParameters["Data"] = (object)Addr;
                ManagementBaseObject managementBaseObject = managementObject.InvokeMethod("GetSetULong", methodParameters, (InvokeMethodOptions)null);
                data = managementBaseObject["Return"];
                return true;
            }
            catch (ManagementException ex)
            {
                Console.WriteLine("GetSetULong failed" + ex.Message);
                return false;
            }
        }

        public static void WMIWriteECRAM(ulong Addr, ulong Value)
        {
            try
            {
                ManagementObject managementObject = new ManagementObject("root\\WMI", "AcpiTest_MULong.InstanceName='ACPI\\PNP0C14\\1_1'", (ObjectGetOptions)null);
                ManagementBaseObject methodParameters = managementObject.GetMethodParameters("GetSetULong");
                Value <<= 16;
                Addr = Value + Addr;
                methodParameters["Data"] = (object)Addr;
                managementObject.InvokeMethod("GetSetULong", methodParameters, (InvokeMethodOptions)null);
                Console.WriteLine("GetSetULong succeed");
            }
            catch (ManagementException ex)
            {
                Console.WriteLine("GetSetULong failed" + ex.Message);
            }
        }

        /* Constructor */
        static WMIEC()
        {
        }

        private class Destructor
        {
            ~Destructor()
            {
            }
        }
    }


    class Program
    {

        public static void SetFanLevel(uint level)
        {
            WMIEC.WMIWriteECRAM(1873UL, 128UL + (ulong)level);
        }
        static private ulong PWM2Byte(uint level)
        {
            ulong num = 0;
            switch (level)
            {
                case 1:
                    num = 60UL;
                    break;
                case 2:
                    num = 80UL;
                    break;
                case 3:
                    num = 100UL;
                    break;
                case 4:
                    num = 120UL;
                    break;
                case 5:
                    num = 140UL;
                    break;
            }
            return num;
        }
        static void Main(string[] args)
        {
            while (true) {
                /* 全速运行 */
                // WMIEC.WMIWriteECRAM(1873UL, 64UL);

                /* 智能能模式 */
                // WMIEC.WMIWriteECRAM(1873UL, 0UL);

                if (false) { 
                    /* 无风 */
                    uint level = 7; /* 0 无风， 1-7，不同档次风 */
                    SetFanLevel(level);
                    Thread.Sleep(3000);
                    SetFanLevel(0);
                }
                /* 自定义不同级别 */
                WMIEC.WMIWriteECRAM(1873UL, 160UL);
                if (false) { 
                    /* L1 45 degree*/
                    WMIEC.WMIWriteECRAM(1859UL, 60UL);
                    /* L2 50 degree*/
                    WMIEC.WMIWriteECRAM(1860UL, 80UL);
                    /* L3 55 degree*/
                    WMIEC.WMIWriteECRAM(1861UL, 100UL);
                    /* L2 60 degree*/
                    WMIEC.WMIWriteECRAM(1862UL, 120UL);
                    /* L2 65 degree*/
                    WMIEC.WMIWriteECRAM(1863UL, 140UL);
                }

                /* 1 - 200 */
                uint allToLevel = 45;
                WMIEC.WMIWriteECRAM(1858UL, allToLevel);
                WMIEC.WMIWriteECRAM(1859UL, allToLevel);
                WMIEC.WMIWriteECRAM(1860UL, allToLevel);
                WMIEC.WMIWriteECRAM(1861UL, allToLevel);
                WMIEC.WMIWriteECRAM(1862UL, allToLevel);
                WMIEC.WMIWriteECRAM(1863UL, allToLevel);
                WMIEC.WMIWriteECRAM(1864UL, allToLevel);


                Thread.Sleep(3000);
            }
        }
    }
}
