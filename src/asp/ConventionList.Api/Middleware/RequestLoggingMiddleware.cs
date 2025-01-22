namespace ConventionList.Api.Middleware;

public class RequestLoggingMiddleware(RequestDelegate next, ILogger<RequestLoggingMiddleware> log)
{
    public async Task Invoke(HttpContext context)
    {
        log.LogInformation(
            "Request: {Method}-{Path}",
            context.Request.Method,
            context.Request.Path
        );
        await next(context);
    }
}
