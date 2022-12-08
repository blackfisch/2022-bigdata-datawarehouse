
using System.Security.Cryptography;
using System.Diagnostics;
using System.Drawing.Text;
using System.Drawing.Printing;

Console.Write("Number of Test-Runs: ");
int RUNS = int.Parse(Console.ReadLine()!);

static string AskWorkPath()
{
    Console.Write("Working Directory: ");
    return Console.ReadLine()!;
}

string workPath = args.Length < 1 ? AskWorkPath() : args[0];
Directory.SetCurrentDirectory(workPath);


string[] py_exec = { 
    "python", 
    Path.Combine(workPath, "python", "corona.py") 
};
string[] r_exec = { 
    "RScript.exe",
    Path.Combine(workPath, "r", "corona.R")
};

string[][] processes = { py_exec, r_exec };
List<double> cpuUsages = new();
List<double> runTimes = new();
List<double> memUsages = new();

foreach (string[] arr in processes)
{
    Process proc = new()
    {
        StartInfo = new ProcessStartInfo()
        {
            FileName = arr[0],
            Arguments = arr[1],
            UseShellExecute = false,
            RedirectStandardOutput = false,
            CreateNoWindow = false
        }
    };

    Console.WriteLine("-----------" + arr[0] + "-----------");

    List<double> cpuUsageHistory = new();
    List<double> processTimeHistory = new();
    List<double> processMemHistory = new();

    for (int i=0; i<RUNS; i++) {
        DateTime lastTime = new();
        DateTime curTime;
        TimeSpan lastTotalProcessorTime = new();
        TimeSpan curTotalProcessorTime = new();
        long lastMemUse = 0;
        proc.Start();
        PerformanceCounter cnt = new PerformanceCounter("Process", "Working Set Peak", proc.ProcessName, true);
        while (!Console.KeyAvailable)
        {
            if (proc.HasExited)
            
                break;

            if (lastTime == new DateTime())
            {
                lastTime = DateTime.Now;
                lastTotalProcessorTime = proc.TotalProcessorTime;
            }
            else
            {
                curTime = DateTime.Now;
                curTotalProcessorTime = proc.TotalProcessorTime;

                double CPUUsage = (curTotalProcessorTime.TotalMilliseconds - lastTotalProcessorTime.TotalMilliseconds) / curTime.Subtract(lastTime).TotalMilliseconds / Convert.ToDouble(Environment.ProcessorCount);
                cpuUsageHistory.Add(CPUUsage);

                lastTime = curTime;
                lastTotalProcessorTime = curTotalProcessorTime;
            }

            lastMemUse = cnt.RawValue;
            Thread.Sleep(1);
        }

        processTimeHistory.Add(curTotalProcessorTime.TotalMilliseconds);
        processMemHistory.Add(lastMemUse / 1048576.0);
    }

    cpuUsages.Add(cpuUsageHistory.Average());
    memUsages.Add(processMemHistory.Average());
    runTimes.Add(processTimeHistory.Average());
}
Console.WriteLine("------------------------------\n\n\n");
Console.WriteLine("-----------RESULTS------------");
Console.WriteLine("Average Resource Usage over " + RUNS + " runs\n\n");
Console.WriteLine("Python: \n" + cpuUsages[0] * 100 + " %\nCPU Times: " + runTimes[0] + " ms\nPeak Memory: " + memUsages[0] + " MB\n\n");
Console.WriteLine("R: \n" + cpuUsages[1] * 100 + " %\nCPU Times: " + runTimes[1] + " ms\nPeak Memory: " + memUsages[1] + " MB");
Console.WriteLine("------------------------------\n");
Console.Write("Press any key to exit...");
Console.ReadLine();