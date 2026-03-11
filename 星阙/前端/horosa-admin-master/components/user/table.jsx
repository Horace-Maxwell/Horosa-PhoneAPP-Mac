"use client";

import * as React from "react";
import { DataTable } from "@/components/table";
import { columns } from "@/components/table/columns/users";
import { DataTableToolbar } from "@/components/table/toolbars/users";
import { StorageUtils } from "@/lib/storage";
import { KEYS } from "@/constant/keys";

export function UserTable() {
  const [users, setUsers] = React.useState([])
  const [total, setTotal] = React.useState(0)
  const [pageIndex, setPageIndex] = React.useState(1)

  const getUsers = ({ page = 1, pageSize = 10 }) => {
    fetch('https://api.horosa.com/admin/consumer/list', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': StorageUtils.get(KEYS.ACCESS_TOKEN),
      },
      body: '{ "page": ' + page + ', "page_size": ' + pageSize + ' }',
    }).then(res => res.json()).then(res => {
      if (res.code === 0) {
        console.log(res.data)
        setUsers(res.data?.data)
        setTotal(res.data?.total || 0)
      }
    })
  }

  React.useEffect(() => {
    getUsers({ page: pageIndex + 1, pageSize: 10 })
  }, [pageIndex])

  return (
    <>
      <DataTable
        data={users}
        columns={columns}
        toolbar={<DataTableToolbar />}
        total={total}
        pageIndex={pageIndex}
        setPageIndex={setPageIndex}
      />
    </>
  )
}
