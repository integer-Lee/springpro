package kr.board.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.board.entity.Board;
import kr.board.mapper.BoardMapper;

@Controller
public class BoardController {
	
	@Autowired
	BoardMapper boardMapper;
	
	@RequestMapping("/")
	public String main() {
		return "main";
	}
	
	// @ResponseBody -> jackson-databind API를 추가해주면 (객체를 -> JSON 데이터포멧으로 변환해준다.)	
	@RequestMapping("/boardList.do")
	public @ResponseBody List<Board> boardList(){
		List<Board> list = boardMapper.getLists();
		return list;  // 스프링은 객체를 JSON 데이터 형식으로 변환(API)해서 리턴(응답)하겠다.
	}
	
	// @ResponseBody -> jackson-databind API를 추가해주면 (객체를 -> JSON 데이터포멧으로 변환해준다.)	
	@RequestMapping("/boardContent.do")
	public @ResponseBody Board boardContent(int idx){	//AJAX에서 보내주는 data key값과 일치해야 한다.
		Board vo = boardMapper.boardContent(idx);
		return vo;  // vo -> JSON타입으로 바뀌어서 AJAX쪽으로 반환된다.
	}
	
	// return타입이 void라고 할지라도 @ResponseBody가 있으면 ajax를 호출한(success)부분으로 넘어간다. 	
	@RequestMapping("/boardInsert.do")
	public @ResponseBody void boardInsert(Board vo){
		boardMapper.boardInsert(vo);	// 등록성공
	}
	
	// @ResponseBody -> jackson-databind API를 추가해주면 (객체를 -> JSON 데이터포멧으로 변환해준다.)	
	@RequestMapping("/boardUpdate.do")
	public @ResponseBody void boardUpdate(Board vo){
		boardMapper.boardUpdate(vo);
	}
		
	// return타입이 void라고 할지라도 @ResponseBody가 있으면 ajax를 호출한(success)부분으로 넘어간다. 	
	@RequestMapping("/boardDelete.do")
	public @ResponseBody void boardDelete(int idx){
		boardMapper.boardDelete(idx);	// 삭제성공
	}
	
	// return타입이 void라고 할지라도 @ResponseBody가 있으면 ajax를 호출한(success)부분으로 넘어간다. 	
	@RequestMapping("/boardCount.do")
	public @ResponseBody Board boardCount(int idx){
		boardMapper.boardCount(idx);	
		Board vo = boardMapper.boardContent(idx);
		return vo;
	}
}
