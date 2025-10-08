@Component
export struct ActionGrid {
  @BuilderParam saveBuilder?: () => void
  @BuilderParam readBuilder?: () => void
  @BuilderParam updateBuilder?: () => void
  @BuilderParam removeBuilder?: () => void

  @Builder private DefaultSave() {
    Button('Save')
      .height(44).width('100%').borderRadius(22)
  }
  @Builder private DefaultRead() {
    Button('Read')
      .height(44).width('100%').borderRadius(22)
  }
  @Builder private DefaultUpdate() {
    Button('Update')
      .height(44).width('100%').borderRadius(22)
  }
  @Builder private DefaultRemove() {
    Button('Remove')
      .height(44).width('100%').borderRadius(22)
  }

  build() {
    Grid() {
      GridItem() {
        if (this.saveBuilder) {
          this.saveBuilder()
        } else {
          this.DefaultSave()
        }
      }
      GridItem() {
        if (this.readBuilder) {
          this.readBuilder()
        } else {
          this.DefaultRead()
        }
      }
      GridItem() {
        if (this.updateBuilder) {
          this.updateBuilder()
        } else {
          this.DefaultUpdate()
        }
      }
      GridItem() {
        if (this.removeBuilder) {
          this.removeBuilder()
        } else {
          this.DefaultRemove()
        }
      }
    }
    .columnsTemplate('1fr 1fr')
    .rowsTemplate('auto auto')
    .columnsGap(6)
    .rowsGap(6)
  }
}
