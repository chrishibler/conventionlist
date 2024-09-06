using ConventionList.Api.Auth;
using Microsoft.AspNetCore.Authorization;

public class HasScopeHandler : AuthorizationHandler<HasScopeRequirement>
{
    protected override Task HandleRequirementAsync(
        AuthorizationHandlerContext context,
        HasScopeRequirement requirement
    )
    {
        if (context.User.HasPermission(requirement.Issuer, requirement.Scopes))
        {
            context.Succeed(requirement);
        }
        return Task.CompletedTask;
    }
}
