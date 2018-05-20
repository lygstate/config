// Decompiled with JetBrains decompiler
// Type: GamingCenter.Utility
// Assembly: GamingCenter, Version=1.0.0.33, Culture=neutral, PublicKeyToken=null
// MVID: AC6C2AAD-0313-4B01-B972-649C5F39DAED
// Assembly location: C:\Program Files\OEM\GamingCenter\GamingCenter.exe

using Microsoft.Win32;
using System;
using System.Diagnostics;
using System.IO;
using System.Threading;

namespace Z6FanControl
{
  public static class Utility
  {
    private static bool b_LogEnable;

    public static object RegistrySoftwareKeyRead(RegistryHive hKey, string SubKey, string Name, object defaultvalue)
    {
      if (Environment.Is64BitOperatingSystem)
        return RegistryKey.OpenBaseKey(hKey, RegistryView.Registry64).OpenSubKey("SOFTWARE" + SubKey).GetValue(Name, defaultvalue);
      return RegistryKey.OpenBaseKey(hKey, RegistryView.Registry32).OpenSubKey("SOFTWARE\\WOW6432Node" + SubKey).GetValue(Name, defaultvalue);
    }

    public static void RegistrySoftwareKeyWrite(RegistryHive hKey, string SubKey, string Name, object setvalue, RegistryValueKind valuekind)
    {
      if (Environment.Is64BitOperatingSystem)
        RegistryKey.OpenBaseKey(hKey, RegistryView.Registry64).CreateSubKey("SOFTWARE" + SubKey).SetValue(Name, setvalue, valuekind);
      else
        RegistryKey.OpenBaseKey(hKey, RegistryView.Registry32).CreateSubKey("SOFTWARE\\WOW6432Node" + SubKey).SetValue(Name, setvalue, valuekind);
    }

    public static void RegistrySoftwareKeyDelete(RegistryHive hKey, string SubKey, string Name)
    {
      if (Environment.Is64BitOperatingSystem)
        RegistryKey.OpenBaseKey(hKey, RegistryView.Registry64).CreateSubKey("SOFTWARE" + SubKey).DeleteValue(Name);
      else
        RegistryKey.OpenBaseKey(hKey, RegistryView.Registry32).CreateSubKey("SOFTWARE\\WOW6432Node" + SubKey).DeleteValue(Name);
    }

    public static object RegistryKeyRead(RegistryHive hKey, string SubKey, string Name, object defaultvalue)
    {
      if (Environment.Is64BitProcess)
        return RegistryKey.OpenBaseKey(hKey, RegistryView.Registry64).OpenSubKey(SubKey).GetValue(Name, defaultvalue);
      return RegistryKey.OpenBaseKey(hKey, RegistryView.Registry32).OpenSubKey(SubKey).GetValue(Name, defaultvalue);
    }

    public static void RegistryKeyWrite(RegistryHive hKey, string SubKey, string Name, object setvalue, RegistryValueKind valuekind)
    {
      if (Environment.Is64BitProcess)
        RegistryKey.OpenBaseKey(hKey, RegistryView.Registry64).CreateSubKey(SubKey).SetValue(Name, setvalue, valuekind);
      else
        RegistryKey.OpenBaseKey(hKey, RegistryView.Registry32).CreateSubKey(SubKey).SetValue(Name, setvalue, valuekind);
    }

    public static void CheckProcessExistAndCreate(string processeName, string path)
    {
      bool flag = false;
      try
      {
        foreach (Process process in Process.GetProcessesByName(processeName))
          flag = true;
      }
      catch
      {
      }
      if (flag)
        return;
      try
      {
        Process.Start(new ProcessStartInfo()
        {
          FileName = processeName,
          WorkingDirectory = path,
          UseShellExecute = true,
          CreateNoWindow = false,
          RedirectStandardInput = false,
          RedirectStandardOutput = false
        });
        Thread.Sleep(1000);
      }
      catch
      {
        Console.WriteLine("CheckProcessExistAndCreate failed");
      }
    }

    public static void EnableLog()
    {
      try
      {
        Utility.b_LogEnable = (int) Utility.RegistryKeyRead(RegistryHive.LocalMachine, "SOFTWARE\\OEM\\GamingCenterService\\Debug", "enable", (object) 0) > 0;
      }
      catch
      {
        Utility.b_LogEnable = false;
        return;
      }
      try
      {
        if ((int) Utility.RegistryKeyRead(RegistryHive.LocalMachine, "SOFTWARE\\OEM\\GamingCenterService\\Debug", "create", (object) 0) <= 0)
          return;
        File.Delete("C:\\GamingCenter.log");
        File.Delete("C:\\GamingCenterFanManagement.log");
      }
      catch
      {
      }
    }

    public static void DisableLog()
    {
      Utility.b_LogEnable = false;
    }

    public static void Log(string logMessage)
    {
      try
      {
        if (Utility.b_LogEnable)
        {
          using (StreamWriter streamWriter = File.AppendText("C:\\GamingCenter.log"))
            streamWriter.WriteLine("{0}", (object) logMessage);
        }
        else
          Console.WriteLine(logMessage);
      }
      catch
      {
      }
    }

    public static void ComputerMonitorLog(string logMessage)
    {
      try
      {
        if (Utility.b_LogEnable)
        {
          using (StreamWriter streamWriter = File.AppendText("C:\\GamingCenterComputerMonitor.log"))
            streamWriter.WriteLine("{0}", (object) logMessage);
        }
        else
          Console.WriteLine(logMessage);
      }
      catch
      {
      }
    }

    public static void MyLightBarLog(string logMessage)
    {
      try
      {
        if (Utility.b_LogEnable)
        {
          using (StreamWriter streamWriter = File.AppendText("C:\\GamingCenterMyLightBarLog.log"))
            streamWriter.WriteLine("{0}", (object) logMessage);
        }
        else
          Console.WriteLine(logMessage);
      }
      catch
      {
      }
    }

    public static void FanManagementLog(string logMessage)
    {
      try
      {
        if (Utility.b_LogEnable)
        {
          using (StreamWriter streamWriter = File.AppendText("C:\\GamingCenterFanManagement.log"))
            streamWriter.WriteLine("{0}", (object) logMessage);
        }
        else
          Console.WriteLine(logMessage);
      }
      catch
      {
      }
    }

    public static void FastSwitchLog(string logMessage)
    {
      try
      {
        if (Utility.b_LogEnable)
        {
          using (StreamWriter streamWriter = File.AppendText("C:\\GamingCenterFastSwitch.log"))
            streamWriter.WriteLine("{0}", (object) logMessage);
        }
        else
          Console.WriteLine(logMessage);
      }
      catch
      {
      }
    }

    public static void CustomizeLog(string logMessage)
    {
      try
      {
        if (Utility.b_LogEnable)
        {
          using (StreamWriter streamWriter = File.AppendText("C:\\GamingCenterCustomizeLog.log"))
            streamWriter.WriteLine("{0}", (object) logMessage);
        }
        else
          Console.WriteLine(logMessage);
      }
      catch
      {
      }
    }

    public static string GetTime()
    {
      return DateTime.Now.ToString("yyyy-MM-dd_hh-mm-ss_fff");
    }
  }
}
