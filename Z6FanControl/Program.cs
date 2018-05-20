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

    public static class MySetting
    {
        public static void WinKeyOnOff()
        {
            object data = (object)0;
            WMIEC.WMIReadECRAM(1895UL, ref data);
            WMIEC.WMIWriteECRAM(1895UL, 1UL + (Convert.ToUInt64(data) & 254UL));
        }

        public static void WinKeyOn()
        {
            if (((long)GetAddrStatusByte() & 1L) == 1L)
            {
                Utility.ComputerMonitorLog("WinKey ON");
                WinKeyOnOff();
            }
        }

        public static void WinKeyOff()
        {
            if (((long)GetAddrStatusByte() & 1L) == 0L)
            {
                Utility.ComputerMonitorLog("WinKey Off");
                WinKeyOnOff();
            }
        }

        public static void LightBarOnOff()
        {
            object data = (object)0;
            WMIEC.WMIReadECRAM(1895UL, ref data);
            WMIEC.WMIWriteECRAM(1895UL, 2UL + (Convert.ToUInt64(data) & 253UL));
        }

        public static void SilentModeOnOff()
        {
            object data = (object)0;
            WMIEC.WMIReadECRAM(1895UL, ref data);
            WMIEC.WMIWriteECRAM(1895UL, 8UL + (Convert.ToUInt64(data) & 247UL));
        }

        public static void USBChargeOn()
        {
            object data = (object)0;
            WMIEC.WMIReadECRAM(1895UL, ref data);
            WMIEC.WMIWriteECRAM(1895UL, 16UL + (Convert.ToUInt64(data) & 239UL));
        }

        public static void USBChargeOff()
        {
            object data = (object)0;
            WMIEC.WMIReadECRAM(1895UL, ref data);
            WMIEC.WMIWriteECRAM(1895UL, Convert.ToUInt64(data) & 239UL);
        }

        public static void TouchPadOnOff()
        {
            object data = (object)0;
            WMIEC.WMIReadECRAM(1885UL, ref data);
            WMIEC.WMIWriteECRAM(1885UL, 4UL + (Convert.ToUInt64(data) & 251UL));
        }

        public static ulong GetAddrStatusByte()
        {
            object Buffer = (object)0; ;
            WMIEC.WMIReadECRAM(1896UL, ref Buffer);
            return Convert.ToUInt64(Buffer);
        }
    }

    class Program
    {

        /// <summary>
        /// 设置灯光以及节能模式
        /// </summary>
        /// <param name="isLightBarOn">是否打开灯光条</param>
        /// <param name="isPowerSaveMode">是否打开节能模式</param>
        /// <param name="isKeyPress">TODO: isKeyPress</param>
        /// <param name="isNoKey">TODO:isNoKey</param>
        /// <returns></returns>
        public static void WriteEC0748Byte(bool isLightBarOn, bool isPowerSaveMode, bool isKeyPress, bool isNoKey)
        {
            byte num = 1;
            if (isLightBarOn)
            {
                Utility.Log(string.Format("[WriteEC0748Byte] AP RGBLBStatus ON"));
                num &= (byte)251;
            }
            else
            {
                Utility.Log("[WriteEC0748Byte] AP RGBLBStatus OFF");
                num |= (byte)4;
            }
            if (isPowerSaveMode)
            {
                Utility.Log("[WriteEC0748Byte] AP PowerSaveMode ON");
                num |= (byte)2;
            }
            else
            {
                Utility.Log("[WriteEC0748Byte] AP PowerSaveMode OFF");
                num &= (byte)253;
            }
            if (isKeyPress)
            {
                Utility.Log("[WriteEC0748Byte] AP isKeyPress set 0x0748H.5 = 1 ");
                num |= (byte)32;
            }
            if (isNoKey)
            {
                Utility.Log("[WriteEC0748Byte] AP isNoKey set 0x0748H.4 = 1 ");
                num |= (byte)16;
            }
            WMIEC.WMIWriteECRAM(1864UL, (ulong)num);
            Utility.Log(string.Format("[WriteEC0748Byte] AP set 0x0748h = 0x{0:X}", (object)num));
        }

        /// <summary>
        /// 设置风扇速度,手动模式
        /// </summary>
        /// <param name="level">风扇速度级别，范围[0,7]，0表示无风</param>
        /// <returns></returns>
        public static void SetFanSpeedManualLevel(uint level)
        {
            WMIEC.WMIWriteECRAM(1873UL, 128UL + (ulong)level);
        }

        static void SetFanSpeedForTemperatureLevel(uint level, uint speed)
        {

            WMIEC.WMIWriteECRAM(1857UL + level, speed);
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
            SetFanSpeedForTemperatureLevel(0U, speed);

            /* L1 45 degree */
            SetFanSpeedForTemperatureLevel(1U, speed);

            /* L2 50 degree */
            SetFanSpeedForTemperatureLevel(2U, speed);

            /* L3 55 degree */
            SetFanSpeedForTemperatureLevel(3U, speed);

            /* L4 60 degree */
            SetFanSpeedForTemperatureLevel(4U, speed + 25);

            /* L5 65 degree */
            SetFanSpeedForTemperatureLevel(5U, speed + 55);

            /* 最高支持70度 */
            /* L6 70 degree */
            SetFanSpeedForTemperatureLevel(6U, speed + 55);
        }

        /// <summary>
        /// 设置状态栏颜色
        /// </summary>
        /// <param name="red_level">风扇速度，范围 [0,36]</param>
        /// <param name="green_level">风扇速度，范围 [0,36]</param>
        /// <param name="blue_level">风扇速度，范围 [0,36]</param>
        /// <returns></returns>
        public static void SetLightBarColor(uint red_level, uint green_level, uint blue_level)
        {
            Utility.MyLightBarLog(string.Format("red 0x0749h = {0}", (object)red_level));
            Utility.MyLightBarLog(string.Format("green 0x074Ah = {0}", (object)green_level));
            Utility.MyLightBarLog(string.Format("blue 0x074Bh = {0}", (object)blue_level));
            WMIEC.WMIWriteECRAM(1865UL, red_level);
            WMIEC.WMIWriteECRAM(1866UL, green_level);
            WMIEC.WMIWriteECRAM(1867UL, blue_level);
        }

        private static void Write_Support_BYTE()
        {
            object data = (object)0;
            WMIEC.WMIReadECRAM(1894UL, ref data);
            WMIEC.WMIWriteECRAM(1894UL, Convert.ToUInt64(data) | 3UL);
        }


        public static void InitKeyboard()
        {
            object data = (object)0;
            WMIEC.WMIReadECRAM(1857UL, ref data);
            WMIEC.WMIWriteECRAM(1857UL, (ulong)(byte)(Convert.ToUInt64(data) & 254UL));
        }

        public static void KeyboardSet_APExistToEC()
        {
            object data = (object)0;
            WMIEC.WMIReadECRAM(1857UL, ref data);
            WMIEC.WMIWriteECRAM(1857UL, (ulong)(byte)((uint)(byte)Convert.ToUInt64(data) | 1U));
        }

        private static void KeyboardEnable_EC_OnkeyPressed()
        {
            object data = (object)0;
            WMIEC.WMIReadECRAM(1857UL, ref data);
            Utility.MyLightBarLog(string.Format("Enable_EC_OnkeyPressed data {0}", (object)data));
            WMIEC.WMIWriteECRAM(1857UL, (ulong)(byte)((uint)(byte)Convert.ToUInt64(data) | 8U));
        }

        private static void InitSilentMode()
        {
            object data = (object)0;
            WMIEC.WMIReadECRAM(1115UL, ref data);
            if (((long)Convert.ToUInt64(data) & 1L) == 1L)
            {
                object data2 = (object)0;
                WMIEC.WMIReadECRAM(1895UL, ref data2);
                WMIEC.WMIWriteECRAM(1895UL, 8UL + (Convert.ToUInt64(data2) & 247UL));
                Utility.Log("[InitSilentMode] Works");
            }
            else
            {
                Utility.Log("[InitSilentMode] Have no SilentMode");
            }
            Utility.Log("[InitSilentMode] End");
        }

        private static void InitUSBCharger()
        {
            object data = (object)0;
            WMIEC.WMIReadECRAM(1895UL, ref data);
            WMIEC.WMIWriteECRAM(1895UL, Convert.ToUInt64(data) & 239UL);
            Utility.Log("[Init USB Charger] End");
        }

        static void Main(string[] args)
        {
            Write_Support_BYTE();

            InitKeyboard();

            InitSilentMode();

            InitUSBCharger();

            MySetting.USBChargeOn();
            MySetting.WinKeyOn();
            // KeyboardSet_APExistToEC();

            // KeyboardEnable_EC_OnkeyPressed();

            WriteEC0748Byte(false, true, true, false);
            MySetting.LightBarOnOff();

            SetLightBarColor(10, 10, 10);

            /* 转速20是最大的没有音量的声音，适合办公或者看电影，比较安静，深夜办公 */
            SetFanSpeed(20);

            /* 转速40是最大的没有音量的声音，适合办公或者看电影，比较安静，白天办公 */
            // SetFanSpeed(40);

            /* 转速45是最大的没有音量的声音，适合办公或者看电影，比较安静，白天办公 */
            // SetFanSpeed(45);

            while (true)
            {
                /* 全速运行 */
                // WMIEC.WMIWriteECRAM(1873UL, 64UL);

                /* 智能能模式 */
                // WMIEC.WMIWriteECRAM(1873UL, 0UL);

                /* 将风扇模式设置为 自定义不同温度的风扇速度 */
                WMIEC.WMIWriteECRAM(1873UL, 160UL);
                Thread.Sleep(500);
                break;
            }
        }
    }
}
