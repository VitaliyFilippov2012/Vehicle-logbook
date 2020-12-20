using System;
using System.ServiceModel;
using System.Threading.Tasks;
using SynchronizationService.Model;

namespace SynchronizationService.Service
{
    [ServiceContract]
    public interface ISoapService
    {
        [OperationContract]
        Task<SynchronizationContract> GetSynchronizationContract(Guid userId, SynchronizationClientDataContract clientSynchronizationDataContract);
    }
}
