import { asset } from '@kit.AssetStoreKit';
import { util } from '@kit.ArkTS';


export const TOKEN_ALIAS: string = 'secure_api_token_v1';
const enc = new util.TextEncoder();
const dec = new util.TextDecoder();
const bytes = (s: string) => enc.encodeInto(s);
const str = (b: Uint8Array | undefined) => (b ? dec.decode(b) : '');


export async function saveSecret(secret: string): Promise<void> {
  const attr: asset.AssetMap = new Map();
  attr.set(asset.Tag.ALIAS, bytes(TOKEN_ALIAS));
  attr.set(asset.Tag.SECRET, bytes(secret));
  attr.set(asset.Tag.ACCESSIBILITY, asset.Accessibility.DEVICE_FIRST_UNLOCKED);
  await asset.add(attr);
}


export async function readSecret(): Promise<string | null> {
  const q: asset.AssetMap = new Map();
  q.set(asset.Tag.ALIAS, bytes(TOKEN_ALIAS));
  const res = await asset.query(q);
  if (!res.length) return null;
  return str(res[0].get(asset.Tag.SECRET) as Uint8Array | undefined);
}


export async function updateSecret(newSecret: string): Promise<void> {
  const q: asset.AssetMap = new Map();
  q.set(asset.Tag.ALIAS, bytes(TOKEN_ALIAS));
  const upd: asset.AssetMap = new Map();
  upd.set(asset.Tag.SECRET, bytes(newSecret));
  await asset.update(q, upd);
}


export async function removeSecret(): Promise<void> {
  const q: asset.AssetMap = new Map();
  q.set(asset.Tag.ALIAS, bytes(TOKEN_ALIAS));
  await asset.remove(q);
}