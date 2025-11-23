import type common from '@ohos.app.ability.common';
import { prefReadToken } from '../services/prefsService';
import { LiteError } from '../types/LiteError';
import { RouterParams } from '../types/RouterParams';

@Entry
@Component
export struct DetailsPage {
  @State value: string = '';
  @State status: string = 'Loading...';

  aboutToAppear() {
    const r = this.getUIContext().getRouter();
    let p: RouterParams | undefined;

    try {
      p = r.getParams() as RouterParams;
    } catch (e) {
      const msg = (e as LiteError)?.message ?? (e as Error).message ?? '';
      this.status = 'Param read failed: ' + msg;
      p = undefined;
    }

    if (p?.token && p.token.length > 0) {
      this.value = p.token;
      this.status = 'Loaded from route param';
      return;
    }

    (async () => {
      try {
        const ctx: common.Context = this.getUIContext().getHostContext()!;
        const v: string | null = await prefReadToken(ctx);
        this.value = v ?? '';
        this.status = v ? 'Loaded from prefs' : 'No token stored';
      } catch (e) {
        const msg = (e as LiteError)?.message ?? (e as Error).message ?? '';
        this.status = 'Read failed: ' + msg;
      }
    })();
  }

  build() {
    Column() {
      Text('Details').fontSize(18).fontWeight(FontWeight.Bold)
      Text('Status: ' + this.status).fontSize(12).opacity(0.8).margin({ top: 8 })
      Text(this.value || '— empty —').fontSize(12).margin({ top: 8 })

      Button('Back')
        .margin({ top: 12 })
        .onClick(() => {
          this.getUIContext().getRouter().back();
        })
    }
    .width('100%')
    .height('100%')
    .padding(16)
  }
}
