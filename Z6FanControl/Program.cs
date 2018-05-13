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

        /// <summary>
        /// 设置风扇速度
        /// </summary>
        /// <param name="speed">风扇速度，范围 [1,200]</param>
        /// <returns></returns>
        static void SetFanSpeed(uint speed)
        {
            /* L0 不知道是否存在 */
            /* L0 40 degree */
            WMIEC.WMIWriteECRAM(1857UL, speed);

            /* L1 45 degree */
            WMIEC.WMIWriteECRAM(1858UL, speed);

            /* L2 50 degree */
            WMIEC.WMIWriteECRAM(1859UL, speed);

            /* L3 55 degree */
            WMIEC.WMIWriteECRAM(1860UL, speed);

            /* L4 60 degree */
            WMIEC.WMIWriteECRAM(1861UL, speed);

            /* L5 65 degree */
            WMIEC.WMIWriteECRAM(1862UL, speed);

            if (false) {
                /* 不确定是否支持 */
                /* L6 70 degree */
                WMIEC.WMIWriteECRAM(1863UL, speed);

                /* L7 75 degree */
                WMIEC.WMIWriteECRAM(1864UL, speed);

                /* L8 80 degree */
                WMIEC.WMIWriteECRAM(1865UL, speed);
            }


            /* 自定义不同温度的风扇速度，现在是将所有风扇速度设置为一样 */
            WMIEC.WMIWriteECRAM(1873UL, 160UL);
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

                /* 转速35是最大的没有音量的声音，适合办公或者看电影，比较安静，深夜办公 */
                SetFanSpeed(35);

                /* 转速45是最大的没有音量的声音，适合办公或者看电影，比较安静，白天办公 */
                // SetFanSpeed(45);

                Thread.Sleep(500);
            }
        }
    }
}
