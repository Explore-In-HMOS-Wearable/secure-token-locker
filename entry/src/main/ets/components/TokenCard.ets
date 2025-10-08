import { Size } from "@ohos/hypium";

@Component
export struct TokenCard {
  @Prop token: string = '';
  @Prop status: string = '';
  @Link masked: boolean;

  private maskToken(s: string, masked: boolean): string {
    if (!s) return '— no token —';
    if (!masked) return s;
    const keep: number = Math.min(4, s.length);
    return '*'.repeat(Math.max(0, s.length - keep)) + s.slice(-keep);
  }

  build() {
    Column() {
      Row() {
        Text('Stored Token')
          .fontSize(14)
          .fontWeight(FontWeight.Medium)
        Blank()
        Image(this.masked ? $r('app.media.lock') : $r('app.media.unlock'))
          .onClick(() => {
            this.masked = !this.masked;
          }).width(30)
          .height(30)

      }.width('100%')

      Text(this.maskToken(this.token, this.masked))
        .fontSize(12)
        .opacity(0.9)
        .margin({ top: 4 })
        .maxLines(1)

      Text('Status: ' + this.status)
        .fontSize(11)
        .opacity(0.75)
        .margin({ top: 6 })
    }
    .padding(10)
    .width('100%')
    .backgroundColor('#1a2127')
    .borderRadius(14)
  }
}