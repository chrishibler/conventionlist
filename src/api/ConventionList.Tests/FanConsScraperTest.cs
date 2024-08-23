using System.Diagnostics;
using HtmlAgilityPack;
using Newtonsoft.Json;
using ConventionList.Api.Mapping.FanCons;

namespace ConventionList.Tests;

public class FanConsScraperTest
{
    [Fact]
    public async Task GetJsonTest()
    {
        string url = "https://fancons.com/events/";
        using var httpClient = new HttpClient();
        var response = await httpClient.GetAsync(url);

        var htmlDoc = new HtmlDocument();
        htmlDoc.LoadHtml(await response.Content.ReadAsStringAsync());
        var node = htmlDoc.DocumentNode.SelectNodes("/html[1]/body[1]/script[1]").First();
        Trace.WriteLine(node);

        string jsonData = node.InnerText;
        // get all events
        var fanconEvents = JsonConvert.DeserializeObject<List<FanConEvent>>(jsonData);



        Console.WriteLine(jsonData);
    }

    [Fact]
    public async Task GetConUrlTest()
    {
        string fanConEventInfoUrl = "https://fancons.com/events/info/21466/anime-new-mexico-2024";
        using var httpClient = new HttpClient();
        var response = await httpClient.GetAsync(fanConEventInfoUrl);

        var htmlDoc = new HtmlDocument();
        htmlDoc.LoadHtml(await response.Content.ReadAsStringAsync());
        foreach (var link in htmlDoc.DocumentNode.SelectNodes("//a[@href]").Where(n => n.InnerText == "Visit Convention Site"))
        {
            string href = link.GetAttributeValue("href", null)
                           .Replace("fancons.com", "conventionlist.org", StringComparison.CurrentCultureIgnoreCase);
        }

    }
}
