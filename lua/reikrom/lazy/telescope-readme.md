# Telescope Search

## Search Tiers

| Tier | grep | files | Excludes |
|------|------|-------|---------|
| **Default** | `ss` | `sf` | build, cache, .next, node_modules, dist, .turbo … |
| **Code only** | `sxs` | `sxf` | + tests, stories, .md/.mdx, .d.ts, .snap |
| **Nuclear** | `sas` | `saf` | nothing (only .gitignore) |
| **QF-scoped** | `sqs` | `sqf` | searching within quickfix list files |

> `ss`/`sf` include markdown and test files — use `sxs`/`sxf` to strip those out.

---

## → Quickfix: pumping results

From **any** picker:
- `<C-q>` — send selected/all results to quickfix (stays in picker)
- `<C-S-q>` — send + immediately open quickfix list

Then use `sqs`/`sqf` to re-search within those files (see Filter Funnel below).

---

## Filter Funnel Workflow

Narrow a large result set step by step by excluding file patterns.

```
ss / sf  ──[<C-q>]──▶  QUICKFIX  ──[sqs / sqf]──▶  picker within QF  ──[<C-e>]──▶  exclude prompt  ──▶  repeat
```

**Concrete example** — find `useAuth` but only in `.ts`, not `.tsx`:

1. `ss` → search "useAuth" → 45 results (mixed `.ts` + `.tsx`)
2. `<C-q>` → send all to quickfix
3. `sqs` → open live grep scoped to those 45 files
4. `<C-e>` → prompt: `Exclude files containing > ` → type `.tsx`
5. Quickfix shrinks 45 → 12, picker reopens automatically on the `.ts` files
6. `<C-e>` again to narrow further, `<CR>` to open, or `<C-q>` to save the filtered set

> Each `<C-e>` mutates the quickfix list in-place — `<leader>q` shows the current state at any point.

---

## Word / String Search

| Key | Action |
|-----|--------|
| `sw` | Search word under cursor |
| `sW` | Search WORD under cursor (broader) |
| `st` | Prompt for grep string |
| `sxw` / `sxW` | Same, code-only (excludes tests/docs) |

All use the same fast exclusions as `ss`.

---

## Quick Reference

### Search
| Key | Action |
|-----|--------|
| `ss` | Live grep (default) |
| `sf` | Find files (default) |
| `sxs` | Live grep — code only |
| `sxf` | Find files — code only |
| `sas` | Live grep — everything |
| `saf` | Find files — everything |
| `sqs` | Live grep in quickfix files |
| `sqf` | Find files in quickfix files |

### Utility
| Key | Action |
|-----|--------|
| `<C-p>` | Git files |
| `sr` | Resume last picker |
| `sk` | Search keymaps |
| `sh` | Search help tags |
| `ls` | List buffers (last used first) |
| `q` | Open quickfix list |

### Inside Picker
| Key | Action |
|-----|--------|
| `<C-q>` | Send to quickfix |
| `<C-S-q>` | Send to quickfix + open |
| `<C-e>` | *(sqs/sqf only)* Exclude files by substring |
| `d` | *(buffer picker only)* Delete buffer |
