using Microsoft.AspNetCore.Authorization;

namespace ConventionList.Api.Auth;

public class HasScopeRequirement(string scope, string issuer) : IAuthorizationRequirement
{
    public string Scopes { get; } = scope;
    public string Issuer { get; } = issuer;
}
