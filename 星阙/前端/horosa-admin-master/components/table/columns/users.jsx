"use client"

import { getRegionStrByAdcode } from "@/lib/region"
import { DataTableColumnHeader } from "../data-table-column-header"
import { gender } from "@/constant/data/data"

export const columns = [
  {
    accessorKey: "name",
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title="用户昵称" />
    ),
    cell: ({ row }) => <div>{row.getValue("name")}</div>,
    enableSorting: false,
    enableHiding: false,
  },
  {
    accessorKey: "sex",
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title="性别" />
    ),
    cell: ({ row }) => <div>{gender[row.getValue("sex")]}</div>,
    enableSorting: false,
    enableHiding: false,
  },
  {
    accessorKey: "birthday",
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title="出生日期" />
    ),
    cell: ({ row }) => <div>{row.getValue("birthday") || '--'}</div>,
    enableSorting: false,
    enableHiding: false,
  },
  {
    accessorKey: "birthplace",
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title="出生地" />
    ),
    cell: ({ row }) => {
      return (<div>
      {
        getRegionStrByAdcode(row.original?.birth_province_id, row.original?.birth_city_id, row.original?.birth_district_id)
      }
    </div>)
    },
    enableSorting: false,
    enableHiding: false,
  },
  {
    accessorKey: "place",
    header: ({ column }) => (
      <DataTableColumnHeader column={column} title="现居地" />
    ),
    cell: ({ row }) => <div>
      {
        getRegionStrByAdcode(row.original?.residence_province_id, row.original?.residence_city_id, row.original?.residence_district_id)
      }
    </div>,
    enableSorting: false,
    enableHiding: false,
  },
]