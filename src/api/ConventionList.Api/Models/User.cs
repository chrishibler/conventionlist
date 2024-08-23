namespace ConventionList.Api.Models;

public class User
{
    public const string ConventionSceneSyncUserId = "convention_scene_sync_user";
    public const string FanConsSyncUserId = "fancons_sync_user";

    public static readonly IEnumerable<string> SyncUserIds = [ConventionSceneSyncUserId, FanConsSyncUserId];

    public string Id { get; set; } = "";

    public Role Role { get; set; } = Role.Member;

    public List<Convention> SubmittedConventions { get; set; } = [];
}
