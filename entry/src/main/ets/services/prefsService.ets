// entry/src/main/ets/services/prefsService.ts
import dataPreferences from '@ohos.data.preferences';
import type common from '@ohos.app.ability.common';
import type { TokenItem } from '../types/TokenItem';

const PREF_FILE = 'secure_prefs';
const KEY_TOKEN = 'token';
const KEY_TOKEN_HISTORY = 'token_history_v1';

async function getPrefs(ctx: common.Context) {
  return await dataPreferences.getPreferences(ctx, PREF_FILE);
}

/** ---- Token (single) ---- */
export async function prefSaveToken(ctx: common.Context, val: string): Promise<void> {
  const prefs = await getPrefs(ctx);
  await prefs.put(KEY_TOKEN, val);
  await prefs.flush();
}

export async function prefReadToken(ctx: common.Context): Promise<string | null> {
  const prefs = await getPrefs(ctx);
  const v = await prefs.get(KEY_TOKEN, '') as string | number | bigint | boolean | object;
  const str = String(v);
  return str ? str : null;
}

export async function prefRemoveToken(ctx: common.Context): Promise<void> {
  const prefs = await getPrefs(ctx);
  await prefs.delete(KEY_TOKEN);
  await prefs.flush();
}

/** ---- History helpers ---- */
function makeTokenItem(value: string, savedAt: number = Date.now()): TokenItem {
  return { value, savedAt } as TokenItem;
}

async function readHistoryRaw(ctx: common.Context): Promise<TokenItem[]> {
  const prefs = await getPrefs(ctx);
  const raw = await prefs.get(KEY_TOKEN_HISTORY, '[]') as string;
  try {
    const arr = JSON.parse(raw) as TokenItem[];
    return Array.isArray(arr) ? arr : [];
  } catch {
    return [];
  }
}

async function writeHistoryRaw(ctx: common.Context, arr: TokenItem[]): Promise<void> {
  const prefs = await getPrefs(ctx);
  await prefs.put(KEY_TOKEN_HISTORY, JSON.stringify(arr));
  await prefs.flush();
}

/** ---- History API ---- */
export async function prefAddTokenToHistory(ctx: common.Context, val: string): Promise<void> {
  const arr = await readHistoryRaw(ctx);
  arr.unshift(makeTokenItem(val)); // son eklenen başa
  await writeHistoryRaw(ctx, arr);
}

export async function prefReadTokenHistory(ctx: common.Context): Promise<TokenItem[]> {
  return await readHistoryRaw(ctx);
}

export async function prefClearTokenHistory(ctx: common.Context): Promise<void> {
  await writeHistoryRaw(ctx, []);
}
