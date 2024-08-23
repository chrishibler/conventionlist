using System.Security.Claims;
using ConventionList.Api.Data;
using ConventionList.Api.Models;

namespace ConventionList.Api.Extensions;

public static class ClaimsPrincipalExtensions
{
    public static string? SubjectId(this ClaimsPrincipal user)
    {
        return user.FindFirstValue(ClaimTypes.NameIdentifier);
    }

    public static async Task<bool> CanManageConvention(this ClaimsPrincipal user,
                                                       ConventionListDbContext db,
                                                       Convention con)
    {
        string? userId = user.SubjectId();
        if (userId == con.SubmitterId)
            return true;

        var dbUser = await db.Users.FindAsync(userId);
        if (dbUser is null)
        {
            return false;
        }

        return dbUser.Role == Role.SuperAdmin;
    }
}
