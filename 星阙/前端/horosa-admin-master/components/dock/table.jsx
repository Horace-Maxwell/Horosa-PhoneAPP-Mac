"use client";

import * as React from "react";
import { DataTable } from "@/components/table";
import { columns } from "@/components/table/columns/docks";
import { StorageUtils } from "@/lib/storage";
import { KEYS } from "@/constant/keys";

export function DockTable() {
  const [docks, setDocks] = React.useState([])

  const getDocks = () => {
    fetch('https://api.horosa.com/admin/quick_link/list', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': StorageUtils.get(KEYS.ACCESS_TOKEN),
      },
    }).then(res => res.json()).then(res => {
      if (res.code === 0) {
        setDocks(res.data)
      }
    })
  }

  React.useEffect(() => {
    getDocks()
  }, [])

  return (
    <>
      <DataTable data={docks} columns={columns({ actions: { list: getDocks } })} />
    </>
  )
}
