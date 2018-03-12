package com.forge.parser.ext;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import org.antlr.v4.runtime.ParserRuleContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.TcamContext;
import com.forge.parser.gen.ForgeParser.Tcam_propertiesContext;

public class TcamContextExt extends AbstractBaseExt {
	private Logger L = LoggerFactory.getLogger(TcamContextExt.class);

	public TcamContextExt(TcamContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public TcamContext getContext() {
		return (TcamContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).number());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof TcamContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + TcamContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	protected int offset;

	@Override
	public void calculateMemoryOffset(AtomicInteger offset) {
		super.calculateMemoryOffset(offset);
		this.offset = offset.get();
	}

	@Override
	public void calculateFieldOffset(AtomicInteger offset) {
		TcamContext ctx = getContext();
		for (int i = 0; i < ctx.tcam_properties().size(); i++) {
			offset.set(0);
			if (ctx.tcam_properties(i).key() != null) {
				getExtendedContextVisitor().visit(ctx.tcam_properties(i)).calculateFieldOffset(offset);
			}
		}
		for (int i = 0; i < ctx.tcam_properties().size(); i++) {
			offset.set(0);
			if (ctx.tcam_properties(i).value() != null) {
				getExtendedContextVisitor().visit(ctx.tcam_properties(i)).calculateFieldOffset(offset);
			}
		}
	}

	@Override
	public void requiredPropertyCheck() {
		TcamContext ctx = getContext();
		HashMap<String, String> propStore = new HashMap<>();
		propStore.put("propName", ctx.TCAM().getText());
		for (int i = 0; i < ctx.tcam_properties().size(); i++) {
			ctx.tcam_properties(i).extendedContext.getSemanticInfo(propStore);
		}
		if (!propStore.containsKey("words")) {
			throw new IllegalStateException("In Tcam words not present in line " + ctx.start.getLine());
		}
		if (!propStore.containsKey("bits")) {
			throw new IllegalStateException("In Tcam not present in line " + ctx.start.getLine());
		}
		if (!propStore.containsKey("portCap")) {
			throw new IllegalStateException("In Tcam PortCap not present in line " + ctx.start.getLine());
		}
		if (!propStore.containsKey("key")) {
			throw new IllegalStateException("In Tcam key is  not present in line " + ctx.start.getLine());
		}
		if (!propStore.containsKey("value")) {
			throw new IllegalStateException("In Tcam value is  not present in line " + ctx.start.getLine());
		}
	}

	@Override
	public void duplicateNamesCheck(String parentName, List<String> blockNames) {
		TcamContext ctx = getContext();
		List<String> keyInTcam = new ArrayList<>();
		for (Tcam_propertiesContext tcam_properties : ctx.tcam_properties()) {
			tcam_properties.extendedContext.duplicateNamesCheck("Tcam", keyInTcam);
		}
	}
}
