package com.yp.sys.dao.workorder.impl;

import org.springframework.stereotype.Repository;

import com.yp.sys.dao.common.impl.BaseDaoImpl;
import com.yp.sys.dao.workorder.IWorkOrderDao;
import com.yp.sys.entity.workorder.WorkOrderInfo;
 /**  
 * @Description: 工单dao
 * @author youxingliu
 * @date 2016年11月17日 上午11:05:51
 */
@Repository("workOrderDao")
public class WorkOrderDaoImpl extends BaseDaoImpl<WorkOrderInfo> implements
		IWorkOrderDao {

}
