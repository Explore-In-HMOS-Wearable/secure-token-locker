import type common from '@ohos.app.ability.common';
import { prefReadTokenHistory, prefClearTokenHistory, prefRemoveToken } from '../services/prefsService';
import type { TokenItem } from '../types/TokenItem';

@Entry
@Component
export struct TokensPage {
  @State items: TokenItem[] = [];
  @State status: string = 'Loading...';

  private fmt(ts: number): string {
    const d: Date = new Date(ts);
    const y: number = d.getFullYear();
    const m: string = (d.getMonth() + 1).toString().padStart(2, '0');
    const day: string = d.getDate().toString().padStart(2, '0');
    const hh: string = d.getHours().toString().padStart(2, '0');
    const mm: string = d.getMinutes().toString().padStart(2, '0');
    return `${y}-${m}-${day} ${hh}:${mm}`;
  }

  private async reload(): Promise<void> {
    const ctx: common.Context = this.getUIContext().getHostContext()!;
    try {
      this.items = await prefReadTokenHistory(ctx);
      this.status = this.items.length ? `Total: ${this.items.length}` : 'No saved tokens';
    } catch {
      this.status = 'Failed to load history';
    }
  }

  aboutToAppear() {
    (async () => { await this.reload(); })();
  }

  @Builder private XSButton(label: string, onTap: () => void, full: boolean = false, top: number = 0) {
    Button(label)
      .height(26)
      .width(full ? '100%' : '46%')
      .borderRadius(10)
      .fontSize(11)
      .padding({ left: 6, right: 6 })
      .margin({ top })
      .onClick(onTap)
  }

  build() {
    Column() {
      Column() {
        Text('Saved Tokens')
          .fontSize(15).fontWeight(FontWeight.Bold)
          .margin({ bottom: 2 })
        Text(this.status).fontSize(9).opacity(0.7)
      }
      .width('100%').padding(6)
      .backgroundColor('#11161a').borderRadius(10)

      List() {
        ForEach(this.items, (it: TokenItem, idx: number) => {
          ListItem() {
            Column() {
              Text(it.value)
                .fontSize(11)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(1)
              Text(this.fmt(it.savedAt))
                .fontSize(9).opacity(0.7)
            }
            .padding(6)
            .backgroundColor('#0f1418')
            .borderRadius(8)
          }
          .margin({ bottom: 4 })
        })

        ListItem() {
          Column() {
            this.XSButton('Clear All (History + Current)', () => {
              const ctx: common.Context = this.getUIContext().getHostContext()!;
              (async () => {
                await prefClearTokenHistory(ctx);
                await prefRemoveToken(ctx);
                await this.reload();
              })();
            }, true)

            this.XSButton('Back', () => {
              this.getUIContext().getRouter().back();
            }, true, 4)
          }
          .width('100%')
          .padding(6)
        }
      }
      .edgeEffect(EdgeEffect.None)
      .margin({ top: 6 })
    }
    .width('100%').padding(6)
    .backgroundColor('#0b0f12')
  }
}
