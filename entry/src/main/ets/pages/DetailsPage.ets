import type common from '@ohos.app.ability.common';
import { prefReadToken } from '../services/PrefsService';
import { LiteError } from '../types/LiteError';
import { NavigationParams } from '../types/NavigationParams';
import { logger } from '../util/Logger';


@Builder
export function DetailsPageBuilder(name: string, param: Object) {
  DetailsPage()
}

@Entry
@Component
export struct DetailsPage {
  @State value: string = '';
  @State status: string = 'Loading...';
  pageInfos: NavPathStack = new NavPathStack();

  aboutToAppear() {
    (async () => {
      try {
        const ctx: common.Context = this.getUIContext().getHostContext()!;
        const v: string | null = await prefReadToken(ctx);
        this.value = v ?? '';
        this.status = v ? 'Loaded from prefs' : 'No token stored';
      } catch (e) {
        const msg = (e as LiteError)?.message ?? (e as Error).message ?? '';
        this.status = `Read failed: ${msg}`;
      }
    })();
  }

  build() {
    NavDestination() {

      Column() {
        Text('Details').fontSize(18).fontWeight(FontWeight.Bold)
        Text(`Status: ${this.status}`).fontSize(12).opacity(0.8).margin({ top: 8 })
        Text(this.value || '— empty —').fontSize(12).margin({ top: 8 })

        Button('Back')
          .margin({ top: 12 })
          .onClick(() => {
            this.pageInfos.pop()
          })
      }
      .width('100%')
      .height('100%')
      .padding(16)
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;

      try {
        const param = (context.pathInfo.param as NavigationParams);

        if (param?.token && param.token.length > 0) {
          this.value = param.token;
          this.status = 'Loaded from navigation param';
          return;
        }
        logger.info(`[DetailPage] token -> ${JSON.stringify(param.token)}`);
      } catch (e) {
        logger.error(`[DetailPage] onReady catch exception: ${JSON.stringify(e)}`);
      }
    })
  }
}
