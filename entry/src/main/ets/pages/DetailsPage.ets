import { prefReadToken } from '../services/prefsService';
import type common from '@ohos.app.ability.common';
import { LiteError } from '../types/LiteError';
import router from '@ohos.router';
import { RouterParams } from '../types/RouterParams';

@Component
@Entry
export struct DetailsPage {
  @State value: string = '';
  @State status: string = 'Loading...';


  aboutToAppear() {
    try {
      const p = router.getParams() as RouterParams;
      if (p?.token && p.token.length > 0) {
        this.value = p.token;
        this.status = 'Loaded from route param';
        return;
      }
    } catch (e) {
      const code = (e as LiteError)?.code !== undefined ? String((e as LiteError).code) : '';
      const msg  = (e as LiteError)?.message ?? (e as Error).message ?? '';
      this.status = 'Param read failed' + (code ? ', code=' + code : '') + (msg ? ', msg=' + msg : '');
    }

    (async () => {
      try {
        const ctx: common.Context = this.getUIContext().getHostContext()!;
        const v: string | null = await prefReadToken(ctx);
        this.value = v ?? '';
        this.status = v ? 'Loaded from prefs' : 'No token stored';
      } catch (e) {
        const code = (e as LiteError)?.code !== undefined ? String((e as LiteError).code) : '';
        const msg  = (e as LiteError)?.message ?? (e as Error).message ?? '';
        this.status = 'Read failed' + (code ? ', code=' + code : '') + (msg ? ', message=' + msg : '');
      }
    })();
  }


  build() {
    Column() {
      Text('Details')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)


      Text('Status: ' + this.status)
        .fontSize(12)
        .opacity(0.8)
        .margin({ top: 8 })


      Text(this.value || '— empty —')
        .fontSize(12)
        .margin({ top: 8 })


      Button('Back')
        .margin({ top: 12 })
        .onClick(() => { router.back(); })
    }
    .width('100%')
    .height('100%')
    .padding(16)
  }
}