using Microsoft.AspNetCore.Authorization;

namespace ConventionList.Api.Auth;

public class HasPermissionHandler : AuthorizationHandler<HasPermissionRequirement>
{
    protected override Task HandleRequirementAsync(
        AuthorizationHandlerContext context,
        HasPermissionRequirement requirement
    )
    {
        var permissions = context.User.Claims.FirstOrDefault(c => c.Type == "permissions");
        if (
            permissions is not null && permissions.Value.Contains(requirement.Permission)
            || permissions!.Value.Contains(Permissions.ManageAllConventions)
        )
        {
            context.Succeed(requirement);
        }
        return Task.CompletedTask;
    }
}
