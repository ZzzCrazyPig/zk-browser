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

import com.crazypig.zkbrowser.entity.ZkNodeInfo;

@Controller
public class ZkClientController {
	
	private final static Logger LOGGER = Logger.getLogger(ZkClientController.class);
	private static String connectString = "10.202.7.88:2181,10.202.7.88:2182,10.202.7.88:2183";
	private CuratorFramework zkClient = null;
	
	public ZkClientController() {
		
	}
	
	@PostConstruct
	public void init() {
		LOGGER.info("init zk client");
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
	public String[] ls(@RequestParam String path) throws Exception {
		List<String> subPathList = zkClient.getChildren().forPath(path);
		String[] subPathArr = new String[subPathList.size()];
		subPathList.toArray(subPathArr);
		return subPathArr;
	}
	
	@RequestMapping("/get")
	@ResponseBody
	public ZkNodeInfo get(@RequestParam String path) throws Exception {
		Stat stat = zkClient.checkExists().forPath(path);
		byte[] data = zkClient.getData().forPath(path);
		ZkNodeInfo zkNodeInfo = new ZkNodeInfo();
		zkNodeInfo.setData(data);
		zkNodeInfo.setDataAsString(new String(data));
		zkNodeInfo.setStat(stat);
		return zkNodeInfo;
	}
	
	private static CuratorFramework getZkClient() {
		CuratorFramework client = CuratorFrameworkFactory.builder()
				.connectString(connectString)
				.retryPolicy(new RetryNTimes(3, 1000))
				.connectionTimeoutMs(5000)
				.build();
		return client;
	}

}
