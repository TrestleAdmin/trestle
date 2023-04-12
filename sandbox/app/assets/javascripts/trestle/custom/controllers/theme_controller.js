var ThemeController = class extends Trestle.ApplicationController {
  static values = {
    variable: {
      type: String,
      default: 'primary'
    }
  }

  connect () {
    this.element.value = getComputedStyle(this.rootElement).getPropertyValue(`--${this.variableValue}`).trim()
    this.update()
  }

  update () {
    this.rootStyle.setProperty(`--${this.variableValue}`, this.element.value)

    const [r, g, b] = this._hexToRgb(this.element.value)
    this.rootStyle.setProperty(`--${this.variableValue}-rgb`, [r, g, b].join(', '))

    const [h, s, l] = this._rgbToHsl(r, g, b)
    this.rootStyle.setProperty(`--${this.variableValue}-h`, h)
    this.rootStyle.setProperty(`--${this.variableValue}-s`, `${s}%`)
    this.rootStyle.setProperty(`--${this.variableValue}-l`, `${l}%`)
  }

  get rootElement () {
    return document.documentElement
  }

  get rootStyle () {
    return this.rootElement.style
  }

  _hexToRgb (h) {
    let r = 0, g = 0, b = 0

    // 3 digits
    if (h.length == 4) {
      r = "0x" + h[1] + h[1]
      g = "0x" + h[2] + h[2]
      b = "0x" + h[3] + h[3]

    // 6 digits
    } else if (h.length == 7) {
      r = "0x" + h[1] + h[2]
      g = "0x" + h[3] + h[4]
      b = "0x" + h[5] + h[6]
    }

    return [+r, +g, +b]
  }

  _rgbToHsl (r, g, b) {
    r /= 255
    g /= 255
    b /= 255

    var cmin = Math.min(r,g,b),
        cmax = Math.max(r,g,b),
        delta = cmax - cmin,
        h = 0,
        s = 0,
        l = 0

    if (delta == 0) {
      h = 0
    } else if (cmax == r) {
      h = ((g - b) / delta) % 6
    } else if (cmax == g) {
      h = (b - r) / delta + 2
    } else {
      h = (r - g) / delta + 4
    }

    h = Math.round(h * 60)

    if (h < 0) {
      h += 360
    }

    l = (cmax + cmin) / 2
    s = delta == 0 ? 0 : delta / (1 - Math.abs(2 * l - 1))
    s = +(s * 100).toFixed(1)
    l = +(l * 100).toFixed(1)

    return [h, s, l]
  }
}
