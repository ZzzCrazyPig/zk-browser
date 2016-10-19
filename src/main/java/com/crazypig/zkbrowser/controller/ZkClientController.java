package com.crazypig.zkbrowser.controller;

import java.util.List;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

import org.apache.curator.framework.CuratorFramework;
import org.apache.curator.framework.CuratorFrameworkFactory;
import org.apache.curator.retry.RetryNTimes;
import org.apache.log4j.Logger;
import org.apache.zookeeper.data.Stat;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.crazypig.zkbrowser.conf.SystemConfig;
import com.crazypig.zkbrowser.entity.AppResult;
import com.crazypig.zkbrowser.entity.ZkNodeInfo;

/**
 * 
 * @author CrazyPig
 * @since 2016-10-18
 *
 */
@Controller
public class ZkClientController {
	
	private final static Logger LOGGER = Logger.getLogger(ZkClientController.class);
	private static String connectString = "localhost:2181";
	private CuratorFramework zkClient = null;
	
	public ZkClientController() {
		
	}
	
	@PostConstruct
	public void init() {
		String _connectString = SystemConfig.getProperty("zkUrl");
		if(_connectString != null && !_connectString.isEmpty()) {
			connectString = _connectString;
		}
		LOGGER.info("init zk client, zkUrl : " + connectString);
		zkClient = getZkClient();
		zkClient.start();
	}
	
	@PreDestroy
	public void destory() {
		LOGGER.info("destory zk client");
		zkClient.close();
	}
	
	@RequestMapping("/ls")
	@ResponseBody
	public AppResult ls(@RequestParam String path) {
		AppResult result = null;
		List<String> subPathList = null;
		try {
			subPathList = zkClient.getChildren().forPath(path);
			String[] subPathArr = new String[subPathList.size()];
			subPathList.toArray(subPathArr);
			result = AppResult.buildSucessResult(subPathArr);
		} catch (Exception e) {
//			e.printStackTrace();
			result = AppResult.buildErrorResult(e.getMessage());
		}
		return result;
	}
	
	@RequestMapping("/get")
	@ResponseBody
	public AppResult get(@RequestParam String path) {
		Stat stat;
		byte[] data = null;
		AppResult result = null;
		try {
			stat = zkClient.checkExists().forPath(path);
			data = zkClient.getData().forPath(path);
			ZkNodeInfo zkNodeInfo = new ZkNodeInfo();
			zkNodeInfo.setData(data);
			zkNodeInfo.setDataAsString(new String(data));
			zkNodeInfo.setStat(stat);
			result = AppResult.buildSucessResult(zkNodeInfo);
		} catch (Exception e) {
//			e.printStackTrace();
			result = AppResult.buildErrorResult(e.getMessage());
		}
		return result;
	}
	
	private static CuratorFramework getZkClient() {
		CuratorFramework client = CuratorFrameworkFactory.builder()
				.connectString(connectString)
				.retryPolicy(new RetryNTimes(3, 1000))
				.connectionTimeoutMs(3000)
				.build();
		return client;
	}

}
