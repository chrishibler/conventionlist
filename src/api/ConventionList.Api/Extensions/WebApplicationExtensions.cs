using System.Net;
using ConventionList.Api.Data;
using ConventionList.Api.Models;
using ConventionList.Api.Services;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.EntityFrameworkCore;

namespace ConventionList.Api.Extensions;

public static class WebApplicationExtensions
{
    public static void Migrate(this WebApplication app)
    {
        using var serviceScope = app
            .Services.GetRequiredService<IServiceScopeFactory>()
            .CreateScope();
        {
            var db = serviceScope.ServiceProvider.GetRequiredService<ConventionListDbContext>();
            db.Database.Migrate();
        }
    }

    public static void ConfigureExceptionHandler(this IApplicationBuilder app, ILogger logger)
    {
        app.UseExceptionHandler(appError =>
        {
            appError.Run(async context =>
            {
                context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                context.Response.ContentType = "application/json";
                var contextFeature = context.Features.Get<IExceptionHandlerFeature>();
                if (contextFeature != null)
                {
                    logger.LogError($"Something went wrong: {contextFeature.Error}");
                    await context.Response.WriteAsync(
                        new ErrorDetails()
                        {
                            StatusCode = context.Response.StatusCode,
                            Message = $"Internal Server Error {contextFeature.Error}",
                        }.ToString()
                    );
                }
            });
        });
    }
}
