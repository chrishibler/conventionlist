using Microsoft.AspNetCore.Authorization;

namespace ConventionList.Api.Auth;

public class HasPermissionRequirement(string permission, string issuer) : IAuthorizationRequirement
{
    public string Permission { get; } = permission;
    public string Issuer { get; } = issuer;
}
