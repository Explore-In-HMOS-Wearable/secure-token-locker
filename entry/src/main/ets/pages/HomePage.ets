import { prefSaveToken, prefReadToken, prefRemoveToken, prefAddTokenToHistory } from '../services/prefsService';
import { TokenCard } from '../components/TokenCard';
import router from '@ohos.router';
import type common from '@ohos.app.ability.common';
import { LiteError } from '../types/LiteError';

@Entry
@Component
export struct HomePage {
  @State status: string = 'Tap Read to load token';
  @State tokenPreview: string = '';
  @State masked: boolean = true;

  aboutToAppear() {
    this.tokenPreview = '';
    this.masked = true;
    this.status = 'Tap Read to load token';
  }


  private async onSave(): Promise<void> {
    try {
      const ctx: common.Context = this.getUIContext().getHostContext()!;
      const val: string = `sk_${Date.now()}`;
      await prefSaveToken(ctx, val);
      await prefAddTokenToHistory(ctx, val);
      this.tokenPreview = val;
      this.status = 'Saved token (prefs)';
    } catch (e) {
      const msg: string = (e as LiteError)?.message ?? (e as Error).message ?? '';
      this.status = 'Save failed' + (msg ? ', message=' + msg : '');
    }
  }


  private async onRead(): Promise<void> {
    try {
      const ctx: common.Context = this.getUIContext().getHostContext()!;
      const v: string | null = await prefReadToken(ctx);
      this.tokenPreview = v ?? '';
      this.status = v ? 'Read token OK' : 'No token stored';
      this.masked = true;
    } catch (e) {
      const msg: string = (e as LiteError)?.message ?? (e as Error).message ?? '';
      this.status = 'Read failed' + (msg ? ', message=' + msg : '');
    }
  }

  private async onUpdate(): Promise<void> {
    try {
      const ctx: common.Context = this.getUIContext().getHostContext()!;
      const newVal: string = `sk_${Date.now()}`;
      await prefSaveToken(ctx, newVal);
      await prefAddTokenToHistory(ctx, newVal);
      this.tokenPreview = newVal;
      this.status = 'Updated token (prefs)';
    } catch (e) {
      const msg: string = (e as LiteError)?.message ?? (e as Error).message ?? '';
      this.status = 'Update failed' + (msg ? ', message=' + msg : '');
    }
  }

  private async onRemove(): Promise<void> {
    try {
      const ctx: common.Context = this.getUIContext().getHostContext()!;
      await prefRemoveToken(ctx);
      this.tokenPreview = '';
      this.status = 'Removed token (prefs)';
      this.masked = true;
    } catch (e) {
      const msg: string = (e as LiteError)?.message ?? (e as Error).message ?? '';
      this.status = 'Remove failed' + (msg ? ', message=' + msg : '');
    }
  }



  @Builder private XSButton(label: string, onTap: () => void, fullWidth: boolean = false, topMargin: number = 0) {
    Button(label)
      .height(26)
      .width(fullWidth ? '100%' : '46%')
      .borderRadius(10)
      .fontSize(11)
      .padding({ left: 6, right: 6 })
      .margin({ top: topMargin })
      .opacity(0.95)
      .onClick(onTap)
  }

  build() {
    Scroll() {
      Column() {
        Column() {
          Text('Secure Token Locker')
            .fontSize(15)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 2 })
          Text('Wearable-friendly demo (Preferences)')
            .fontSize(8.5)
            .opacity(0.7)
        }
        .width('100%')
        .padding(6)
        .backgroundColor('#11161a')
        .borderRadius(10)

        TokenCard({
          token: this.tokenPreview,
          status: this.status,
          masked: $masked
        })
          .margin({ top: 6 })

        Row() {
          this.XSButton('Save', () => this.onSave())
          this.XSButton('Read', () => this.onRead())
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: 6 })

        Row() {
          this.XSButton('Update', () => this.onUpdate())
          this.XSButton('Remove', () => this.onRemove())
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ top: 4 })

        this.XSButton('Go to Details', () => {
          router.pushUrl({
            url: 'pages/DetailsPage',
            params: { token: this.tokenPreview }
          }).catch((e: Error | LiteError) => {
            const code: string = (e as LiteError)?.code !== undefined ? String((e as LiteError).code) : '';
            const msg: string  = (e as LiteError)?.message ?? (e as Error).message ?? '';
            this.status = 'pushUrl failed' + (code ? ', code=' + code : '') + (msg ? ', message=' + msg : '');
          });
        }, true, 6)


        this.XSButton('Saved Tokens', () => {
          router.pushUrl({ url: 'pages/TokensPage' })
            .catch((e: Error | LiteError) => {
              const code: string = (e as LiteError)?.code !== undefined ? String((e as LiteError).code) : '';
              const msg: string  = (e as LiteError)?.message ?? (e as Error).message ?? '';
              this.status = 'pushUrl failed' + (code ? ', code=' + code : '') + (msg ? ', message=' + msg : '');
            });
        }, true,4)
      }
      .width('100%')
      .padding(6)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0b0f12')
  }
}
