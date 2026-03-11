export class StorageUtils {

  static get(key) {
    return localStorage.getItem(key)
  }

  static set(key, value) {
    localStorage.setItem(key, value)
  }

  static remove(key) {
    localStorage.removeItem(key)
  }

  static clear() {
    localStorage.clear()
  }
}