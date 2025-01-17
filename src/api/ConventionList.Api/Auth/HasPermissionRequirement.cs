using Microsoft.AspNetCore.Authorization;

namespace ConventionList.Api.Auth;

public record HasPermissionRequirement(string Permission) : IAuthorizationRequirement { }
