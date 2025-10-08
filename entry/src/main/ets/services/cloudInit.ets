import { cloudCommon } from '@kit.CloudFoundationKit';
import { request } from '@kit.BasicServicesKit';
import { LiteError } from '../types/LiteError';

class MyAuthProvider implements cloudCommon.AuthProvider {
  private accessToken: string = '';
  async getAccessToken(isForceRefresh: boolean): Promise<string> {
    if (isForceRefresh || !this.accessToken) {
      this.accessToken = 'mock_access_token_' + Date.now();
    }
    return this.accessToken;
  }
}


export async function initCloud(): Promise<void> {
  try {
    const provider = new MyAuthProvider();
    cloudCommon.init({
      region: cloudCommon.CloudRegion.GERMANY,
      authProvider: provider,
      functionOptions: { timeout: 10_000 },
      storageOptions: { mode: request.agent.Mode.BACKGROUND, network: request.agent.Network.ANY },
      databaseOptions: { schema: 'schema.json', traceId: 'a1b2c3' }
    });
  } catch (e) {
  const code = (e as LiteError)?.code !== undefined ? String((e as LiteError).code) : '';
  const msg  = (e as LiteError)?.message ?? (e as Error).message ?? '';
  console.error('[cloudInit] failed' + (code ? ', code=' + code : '') + (msg ? ', message=' + msg : ''));
}
}