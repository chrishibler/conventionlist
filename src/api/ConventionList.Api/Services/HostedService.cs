namespace ConventionList.Api.Services;

public abstract class HostedService : IHostedService, IDisposable
{
    protected Timer? Timer { get; set; }

    public abstract Task StartAsync(CancellationToken cancellationToken);

    public abstract Task StopAsync(CancellationToken cancellationToken);

#pragma warning disable CA1816 // Dispose methods should call SuppressFinalize
    public void Dispose()
#pragma warning restore CA1816 // Dispose methods should call SuppressFinalize
    {
        Timer?.Dispose();
    }

}
