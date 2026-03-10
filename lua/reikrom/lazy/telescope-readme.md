# Telescope Keybindings

## Search
- `<leader>ss` - Live grep
- `<leader>sf` - Find files
- `<leader>st` - Grep string (prompts for input)
- `<leader>sw` - Search word under cursor
- `<leader>sW` - Search WORD under cursor
- `<leader>sh` - Search help tags

## Search All (includes hidden/ignored)
- `<leader>sas` - Live grep (all files)
- `<leader>saf` - Find files (all files)

## Search Exclude (filters out tests/docs/generated)
- `<leader>sxs` - Live grep
- `<leader>sxf` - Find files
- `<leader>sxw` - Search word under cursor
- `<leader>sxW` - Search WORD under cursor

## Git
- `<C-p>` - Git files

## Navigation
- `<leader>sr` - Resume last picker
- `<leader>sk` - Search keymaps
- `<leader>ls` - List buffers (last used)
- `<leader>q` - Open quickfix list

## Inside Picker
- `<C-q>` - Send to quickfix
- `<C-S-q>` - Send to quickfix + open
- `d` - Delete buffer (buffer picker only)

## Inside Q-list Picker (Filter Funnel)
- `<leader>sqs` - Live grep in quickfix files
- `<leader>sqf` - Find files in quickfix files
- `<C-e>` - Exclude files by substring, refresh picker

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           FILTER FUNNEL                                     │
└─────────────────────────────────────────────────────────────────────────────┘

 ┌──────────────┐
 │  START HERE  │
 └──────┬───────┘
        │
        ▼
┌───────────────────┐      Results in       ┌─────────────────────┐
│  ss (live grep)   │─────────────────────▶ │  Telescope Picker   │
│  sf (find files)  │                       │  (floating modal)   │
└───────────────────┘                       └──────────┬──────────┘
                                                       │
                                                       │ <C-q> send to quickfix
                                                       ▼
                                            ┌─────────────────────┐
                                            │    QUICKFIX LIST    │
                                            │  (45 items, mixed   │
                                            │   .ts and .tsx)     │
                                            └──────────┬──────────┘
                                                       │
                         ┌─────────────────────────────┼─────────────────────────────┐
                         │                             │                             │
                         ▼                             ▼                             ▼
              ┌─────────────────┐          ┌─────────────────┐          ┌─────────────────┐
              │ sqs (grep in Q) │          │ sqf (files in Q)│          │    <leader>q    │
              │                 │          │                 │          │  (open Q list)  │
              └────────┬────────┘          └────────┬────────┘          └─────────────────┘
                       │                            │
                       └──────────┬─────────────────┘
                                  │
                                  ▼
                       ┌─────────────────────┐
                       │   Telescope Picker  │
                       │   (searching within │
                       │    quickfix files)  │
                       └──────────┬──────────┘
                                  │
                                  │ <C-e> exclude
                                  ▼
                       ┌─────────────────────┐
                       │  Prompt appears:    │
                       │  "Exclude files     │
                       │   containing > "    │
                       │                     │
                       │  You type: .tsx     │
                       └──────────┬──────────┘
                                  │
                                  ▼
                       ┌─────────────────────┐
                       │   QUICKFIX LIST     │
                       │   FILTERED IN-PLACE │
                       │                     │
                       │   45 → 12 items     │
                       │   (excluded .tsx)   │
                       └──────────┬──────────┘
                                  │
                                  │ auto re-opens picker
                                  ▼
                       ┌─────────────────────┐
                       │   Telescope Picker  │◀─────────┐
                       │   (now showing only │          │
                       │    12 .ts files)    │          │
                       └──────────┬──────────┘          │
                                  │                     │
                                  │ <C-e> again         │
                                  │ (exclude more)      │
                                  └─────────────────────┘
                                  │
                                  │ <C-q> or <Enter>
                                  ▼
                       ┌─────────────────────┐
                       │   DONE / CONTINUE   │
                       │                     │
                       │ • Send to Q again   │
                       │ • Open file         │
                       │ • Keep refining     │
                       └─────────────────────┘
```
