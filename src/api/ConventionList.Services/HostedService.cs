using Microsoft.Extensions.Hosting;

namespace ConventionList.Services;

public abstract class HostedService : IHostedService, IDisposable
{
    private readonly Timer timer;

    public HostedService(TimeSpan dueTime, TimeSpan period)
    {
        timer = new Timer(async (state) => await DoWork(state), null, dueTime, period);
    }

    public virtual Task StartAsync(CancellationToken cancellationToken) => Task.CompletedTask;

    public virtual Task StopAsync(CancellationToken cancellationToken)
    {
        timer.Change(Timeout.Infinite, 0);
        return Task.CompletedTask;
    }

    protected abstract Task DoWork(object? state);

#pragma warning disable CA1816 // Dispose methods should call SuppressFinalize
    public void Dispose()
#pragma warning restore CA1816 // Dispose methods should call SuppressFinalize
    {
        timer.Dispose();
    }
}
