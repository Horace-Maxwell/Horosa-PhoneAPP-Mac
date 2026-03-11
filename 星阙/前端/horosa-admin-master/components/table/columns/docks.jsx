"use client"

import * as React from "react";
import Image from "next/image";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"
import { DataTableColumnHeader } from "../data-table-column-header"
import DockEditForm from "@/components/forms/dock-form";

export const columns = ({ actions }) => ([
  {
    accessorKey: "name",
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title="金刚区名称" />
    ),
    cell: ({ row }) => <div>{row.getValue("name")}</div>,
    enableSorting: false,
    enableHiding: false,
  },
  {
    accessorKey: "logo",
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title="图标" />
    ),
    cell: ({ row }) => <div>
      <Image src={row.getValue("logo")} alt="logo" width={36} height={36} />
    </div>,
    enableSorting: false,
    enableHiding: false,
  },
  {
    accessorKey: "ident",
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title="标识" />
    ),
    cell: ({ row }) => <div>{row.getValue("ident")}</div>,
    enableSorting: false,
    enableHiding: false,
  },
  {
    accessorKey: "sort",
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title="排序" />
    ),
    cell: ({ row }) => <div>{row.getValue("sort")}</div>,
    enableSorting: false,
    enableHiding: false,
  },
  {
    accessorKey: "status",
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title="状态" />
    ),
    cell: ({ row }) => <div>
      {row.getValue("status") === 1 ? "启用" : "禁用"}
    </div>,
    enableSorting: false,
    enableHiding: false,
  },
  {
    id: "actions",
    header: () => <span>操作</span>,
    cell: ({ row }) => <DockEditFormRow actions={actions} row={row} />,
  },
]);

const DockEditFormRow = ({ actions, row }) => {
  const [open, setOpen] = React.useState(false);

  const handleClose = () => {
    setOpen(false);
    actions?.list?.();
  };

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger>编辑</DialogTrigger>
      <DialogContent className="sm:max-w-[425px]">
        <DialogHeader>
          <DialogTitle>编辑</DialogTitle>
        </DialogHeader>
        <DockEditForm record={row.original}  onClose={handleClose} />
      </DialogContent>
    </Dialog>
  )
}