using System;
using System.IO;
using System.Net;
using System.Net.Mail;
using log4net;

[assembly: log4net.Config.XmlConfigurator(Watch = true)]

namespace ServerMonitor
{
    class Program
    {
        private static readonly ILog log = LogManager.GetLogger(typeof(Program));

        static void Main(string[] args)
        {
            bool ok = false;
            
            log.Info("Checking GCC is online.");

            try
            {
                HttpWebRequest req =
                    WebRequest.CreateHttp("http://dixon.iplantcollaborative.org/compositaeweb/");
                req.Headers.Add("Accept-Language", "en");
                var resp = req.GetResponse();
                var reader = new StreamReader(resp.GetResponseStream());
                var result = reader.ReadToEnd();
                reader.Close();

                ok = result.Contains("form name=\"form1\"");
            }
            catch (Exception ex)
            {
                log.Warn("Failed to contact GCC server", ex);
            }

            if (!ok)
            {
                try
                {
                    var msg = new MailMessage("admin@compositae.org", "richardsk777@gmail.com", "GCC",
                        "GCC Website Down! Contact iPlant support, support@iplantcollaborative.org.");
                    using (var client = new SmtpClient())
                    {
                        client.UseDefaultCredentials = true;
                        client.Host = "smtp.gmail.com";
                        client.Port = 587;
                        client.Credentials = new NetworkCredential("nonpolicyowner@gmail.com", "n0np0licy0wner");
                        client.EnableSsl = true;
                        client.Send(msg);
                    }

                    log.Warn("GCC server down message sent.");
                }
                catch (Exception ex)
                {
                    log.Error("Failed to send warning email for GCC server inactivity", ex);
                }
            }
            else
            {
                log.Info("GCC online check passed.");
            }
        }
    }
}
