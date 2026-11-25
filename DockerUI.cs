using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using Microsoft.Win32;
using VGCore = global::Corel.Interop.VGCore;

namespace JXLNovorius {
 public sealed class DockerUI : UserControl {
  readonly VGCore.Application app;
  readonly Button browse;
  readonly Border drop;
  readonly TextBlock status;
  readonly ProgressBar progress;
  readonly ComboBox format; readonly Slider quality; readonly CheckBox saveMode;
  static Brush Ink(string hex) { return (Brush)new BrushConverter().ConvertFromString(hex); }
  static TextBlock Label(string text, double size, string color) { return new TextBlock { Text=text, FontSize=size, Foreground=Ink(color), TextWrapping=TextWrapping.Wrap }; }
  bool busy;
  readonly TextBox debugLog;
  readonly CheckBox debugMode;
  readonly TextBlock qualityLabel;
  readonly string logPath=Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),"JXLNovorius","conversion.log");
  void Log(string message) {
   string line=DateTime.Now.ToString("HH:mm:ss.fff")+" | "+message;
   if(debugLog.Text.Length>60000) debugLog.Text=debugLog.Text.Substring(debugLog.Text.Length-30000);
   debugLog.AppendText(line+Environment.NewLine); debugLog.ScrollToEnd();
   try { Directory.CreateDirectory(Path.GetDirectoryName(logPath)); File.AppendAllText(logPath,DateTime.Now.ToString("yyyy-MM-dd ")+line+Environment.NewLine); } catch(IOException) {} catch(UnauthorizedAccessException) {}
  }
  void UpdateQuality() {
   string f=format.SelectedItem as string;
   bool applies=saveMode.IsChecked==true && (f=="JPG" || f=="WEBP");
   quality.IsEnabled=!busy && applies;
   qualityLabel.Text=applies ? "Quality: "+(int)quality.Value+" / 100"+(f=="WEBP" && quality.Value==100?" (lossless)":"") : "Quality: N/A ("+(saveMode.IsChecked==true?f:"PNG import")+")";
  }
  readonly string home = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
  public DockerUI(VGCore.Application application) {
   app = application;
   try { string logs=Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),"JXLNovorius"); Directory.CreateDirectory(logs); File.AppendAllText(Path.Combine(logs,"addon.log"),DateTime.Now.ToString("s")+" DockerUI constructor entered v0.5.1\n"); } catch {}
   Background=Ink("#111827");
   var panel = new StackPanel { Margin = new Thickness(16) };
   panel.Children.Add(Label("NOVORIUS / IMAGE LAB",10,"#5EEAD4"));
   var title=Label("JXL Novorius",24,"#F1F5F9"); title.FontWeight=FontWeights.SemiBold; title.Margin=new Thickness(0,5,0,4); panel.Children.Add(title);
   panel.Children.Add(Label("JPEG XL workspace",12,"#94A3B8"));
   drop = new Border { BorderBrush=Ink("#507C83"), BorderThickness=new Thickness(1), CornerRadius=new CornerRadius(14), Padding=new Thickness(16), Margin=new Thickness(0,18,0,12), Background=Ink("#1D2C3C"), AllowDrop=true };
   var dropText=Label("DROP JPEG XL FILES\n\nDrag images here to process",13,"#C7F9EF"); dropText.TextAlignment=TextAlignment.Center; dropText.Padding=new Thickness(0,24,0,24); drop.Child=dropText;
   drop.DragOver += OnDragOver; drop.Drop += OnDrop; panel.Children.Add(drop);
   saveMode=new CheckBox { Content="Save converted files beside originals", Foreground=Ink("#E2E8F0"), Margin=new Thickness(0,8,0,12), IsChecked=false }; panel.Children.Add(saveMode);
   panel.Children.Add(Label("OUTPUT FORMAT (save mode)",11,"#94A3B8"));
   format=new ComboBox { Margin=new Thickness(0,6,0,12), Padding=new Thickness(8), Background=Ink("#263448"), Foreground=Ink("#111827") }; foreach(string f in new[]{"PNG","GIF","JPG","WEBP","TIFF","BMP"}) format.Items.Add(f); format.SelectedIndex=0; panel.Children.Add(format);
   qualityLabel=Label("Quality: 95 / 100 (JPG, WebP)",11,"#CBD5E1"); panel.Children.Add(qualityLabel);
   quality=new Slider { Minimum=1,Maximum=100,Value=95, TickFrequency=1, IsSnapToTickEnabled=true, Margin=new Thickness(0,6,0,12) }; quality.ValueChanged+=(s,e)=>UpdateQuality(); panel.Children.Add(quality);
   browse = new Button { Content="Browse JPEG XL", Padding=new Thickness(12), Margin=new Thickness(0,8,0,12), Background=Ink("#5EEAD4"), Foreground=Ink("#102A30"), BorderThickness=new Thickness(0), FontWeight=FontWeights.SemiBold };
   browse.Click += OnBrowse; panel.Children.Add(browse);
   progress = new ProgressBar { Height=4, Foreground=Ink("#A78BFA"), IsIndeterminate=true, Visibility=Visibility.Collapsed }; panel.Children.Add(progress);
   status=Label("Ready. Import mode uses PNG; save mode uses selected format.",12,"#CBD5E1"); status.Margin=new Thickness(0,12,0,0); panel.Children.Add(status);
   debugMode=new CheckBox { Content="Show live conversion log", IsChecked=true, Foreground=Ink("#5EEAD4"), Margin=new Thickness(0,16,0,8) }; panel.Children.Add(debugMode);
   var debugPanel=new StackPanel();
   debugLog=new TextBox { IsReadOnly=true, AcceptsReturn=true, TextWrapping=TextWrapping.Wrap, Height=180, VerticalScrollBarVisibility=ScrollBarVisibility.Auto, Background=Ink("#0B1220"), Foreground=Ink("#C7F9EF"), BorderBrush=Ink("#334155"), FontFamily=new FontFamily("Consolas"), FontSize=11, Padding=new Thickness(6) }; debugPanel.Children.Add(debugLog);
   var actions=new WrapPanel { Margin=new Thickness(0,6,0,0) };
   var copy=new Button { Content="Copy log", Padding=new Thickness(8), Margin=new Thickness(0,0,6,0) }; copy.Click+=(s,e)=>{try { Clipboard.SetText(debugLog.Text); } catch(Exception ex) {status.Text=ex.Message;} }; actions.Children.Add(copy);
   var clear=new Button { Content="Clear view", Padding=new Thickness(8) }; clear.Click+=(s,e)=>debugLog.Clear(); actions.Children.Add(clear); debugPanel.Children.Add(actions); panel.Children.Add(debugPanel);
   debugMode.Checked+=(s,e)=>debugPanel.Visibility=Visibility.Visible; debugMode.Unchecked+=(s,e)=>debugPanel.Visibility=Visibility.Collapsed;
   format.SelectionChanged+=(s,e)=>UpdateQuality(); saveMode.Checked+=(s,e)=>UpdateQuality(); saveMode.Unchecked+=(s,e)=>UpdateQuality(); UpdateQuality();
   Log("Docker ready. Live events; no simulated progress.");
   var foot=Label("v0.5.1 debug / libjxl",10,"#8194AB"); foot.Margin=new Thickness(0,20,0,0); panel.Children.Add(foot);
   Content = new ScrollViewer { Content=panel, Background=Ink("#111827"), VerticalScrollBarVisibility=ScrollBarVisibility.Auto };
  }
  static string[] Files(IDataObject data) { return data.GetDataPresent(DataFormats.FileDrop) ? (data.GetData(DataFormats.FileDrop) as string[] ?? new string[0]) : new string[0]; }
  static bool Jxl(string path) { return String.Equals(Path.GetExtension(path), ".jxl", StringComparison.OrdinalIgnoreCase) && File.Exists(path); }
  void OnDragOver(object s, DragEventArgs e) { e.Effects=!busy && Files(e.Data).Any(Jxl) ? DragDropEffects.Copy : DragDropEffects.None; e.Handled=true; }
  async void OnDrop(object s, DragEventArgs e) { e.Handled=true; if(!busy) await ImportFiles(Files(e.Data).Where(Jxl).ToArray()); }
  async void OnBrowse(object s, RoutedEventArgs e) { if(busy) return; var picker=new OpenFileDialog { Filter="JPEG XL (*.jxl)|*.jxl", Multiselect=true }; if(picker.ShowDialog()==true) await ImportFiles(picker.FileNames); }
  static string Quote(string s) { return "\""+s+"\""; }
  static string RunEngine(string engine,string args,IProgress<string> log) {
   var psi=new ProcessStartInfo(engine,args) { UseShellExecute=false, CreateNoWindow=true, RedirectStandardError=true, RedirectStandardOutput=true, WorkingDirectory=Path.GetDirectoryName(engine) };
   using(var p=new Process { StartInfo=psi }) {
    var errors=new StringBuilder();
    p.ErrorDataReceived+=(sender,e)=>{if(e.Data!=null){errors.AppendLine(e.Data); log.Report("ENGINE | "+e.Data);}};
    if(!p.Start()) throw new IOException("Cannot start decoder.");
    p.BeginErrorReadLine(); var stdout=p.StandardOutput.ReadToEndAsync();
    if(!p.WaitForExit(300000)){try{p.Kill();p.WaitForExit();}catch{} throw new TimeoutException("Decoder timed out.");}
    p.WaitForExit(); string result=stdout.GetAwaiter().GetResult().Trim();
    log.Report("Process exit code: "+p.ExitCode);
    if(p.ExitCode!=0) throw new IOException("Decoder exit "+p.ExitCode+": "+errors.ToString());
    return result;
   }
  }
  static string Decode(string engine, string job, string source,IProgress<string> log) {
   File.WriteAllText(Path.Combine(job,"input.txt"),source,Encoding.Unicode);
   RunEngine(engine,"job "+Quote(job)+" --live",log);
   string result=Path.Combine(job,"result.txt"); string detail=File.Exists(result)?File.ReadAllText(result,Encoding.Unicode):"No decoder report.";
   if(!detail.StartsWith("OK",StringComparison.Ordinal) || !File.Exists(Path.Combine(job,"image.png"))) throw new IOException(detail);
   return detail.Replace("\r", "").Replace("\n", " ");
  }
  static string ExportFile(string engine,string source,string output,string fmt,int q,IProgress<string> log) {
   string result=RunEngine(engine,"export "+Quote(source)+" "+Quote(output)+" --format "+fmt+" --quality "+q+" --live",log);
   if(!File.Exists(output)) throw new IOException("Output file missing.");
   return result;
  }
  static string NewOutput(string source,string fmt) { string stem=Path.Combine(Path.GetDirectoryName(source),Path.GetFileNameWithoutExtension(source)); string p=stem+"."+fmt; int i=1; while(File.Exists(p))p=stem+"-"+(i++)+"."+fmt; return p; }
  async Task ImportFiles(string[] paths) {
   if(busy || paths.Length==0) return;
   busy=true; browse.IsEnabled=false; saveMode.IsEnabled=false; format.IsEnabled=false; quality.IsEnabled=false; progress.Visibility=Visibility.Visible;
   int done=0; string job=null;
   var clock=Stopwatch.StartNew(); IProgress<string> live=new Progress<string>(Log);
   Log("Batch started: "+paths.Length+" file(s)");
   try {
    if(saveMode.IsChecked==true) {
     string fmt=((string)format.SelectedItem).ToLowerInvariant(); int q=(int)quality.Value; string converter=Path.Combine(home,"engine","novorius.exe");
     foreach(string source in paths){ string output=NewOutput(source,fmt); status.Text="Saving "+Path.GetFileName(output);
      var timer=Stopwatch.StartNew(); Log("Source: "+source); Log("Save "+fmt.ToUpperInvariant()+" | slider="+q+" | effective quality="+((fmt=="jpg"||fmt=="webp")?q.ToString():"N/A"));
      string report=await Task.Run(()=>ExportFile(converter,source,output,fmt,q,live)); done++;
      Log("Result: "+report); Log("Saved: "+output+" | "+new FileInfo(output).Length+" bytes | "+timer.ElapsedMilliseconds+" ms"); }
     status.Text="Saved "+done+" file(s) beside originals."; return;
    }
    if(app.Documents.Count==0) throw new InvalidOperationException("Open or create a CorelDRAW document first.");
    VGCore.Document doc=app.ActiveDocument; VGCore.Layer layer=app.ActiveLayer;
    string engine=Path.Combine(home,"engine","novorius.exe");
    if(!File.Exists(engine)) throw new FileNotFoundException("Decoder missing. Reinstall JXL Novorius.",engine);
    foreach(string source in paths) {
     if(!Jxl(source)) throw new IOException("Invalid input: "+source);
     job=Path.Combine(Path.GetTempPath(),"JXLNovorius-"+Guid.NewGuid().ToString("N")); Directory.CreateDirectory(job);
     status.Text="Decoding "+Path.GetFileName(source)+" ("+(done+1)+"/"+paths.Length+")";
     string currentJob=job;
     var timer=Stopwatch.StartNew(); Log("Source: "+source); Log("Import PNG | lossless | quality slider N/A");
     string report=await Task.Run(()=>Decode(engine,currentJob,source,live)); Log("Decoder report: "+report);
     // Continuation returns to the WPF dispatcher. Never access Corel COM on worker threads.
     if(app.Documents.Count==0 || !Object.ReferenceEquals(doc,app.ActiveDocument) || !Object.ReferenceEquals(layer,app.ActiveLayer)) throw new InvalidOperationException("Active document or layer changed during decoding. Retry on the intended layer.");
     status.Text="Importing bitmap..."; Log("CorelDRAW ImportEx started");
     int before=layer.Shapes.Count;
     doc.ClearSelection();
     var filter=layer.ImportEx(Path.Combine(job,"image.png"),VGCore.cdrFilter.cdrPNG);
     if(filter==null) throw new IOException("PNG import filter unavailable.");
     filter.Finish();
     if(layer.Shapes.Count<=before) throw new IOException("No new object detected after import.");
     done++; Log("CorelDRAW objects: "+before+" -> "+layer.Shapes.Count+" | "+timer.ElapsedMilliseconds+" ms");
     try { Directory.Delete(job,true); } catch(IOException) {} catch(UnauthorizedAccessException) {}
     job=null;
    }
    status.Text="Imported "+done+" image(s).";
   } catch(Exception ex) {
    status.Text="Completed "+done+"/"+paths.Length+". Error: "+ex.Message+(job==null?"":"\nFiles retained: "+job);
    Log("ERROR | "+ex.ToString());
    try { string logs=Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),"JXLNovorius"); Directory.CreateDirectory(logs); File.AppendAllText(Path.Combine(logs,"addon.log"),DateTime.Now.ToString("s")+" "+status.Text+"\n"+ex+"\n"); } catch {}
   } finally { Log("Batch ended: "+done+"/"+paths.Length+" | "+clock.ElapsedMilliseconds+" ms"); busy=false; browse.IsEnabled=true; saveMode.IsEnabled=true; format.IsEnabled=true; UpdateQuality(); progress.Visibility=Visibility.Collapsed; }
  }
 }
}
