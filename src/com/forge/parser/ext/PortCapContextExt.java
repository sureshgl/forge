package com.forge.parser.ext;

import java.util.HashMap;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.IR.IPortCap;
import com.forge.parser.gen.ForgeParser.PortCapContext;

public class PortCapContextExt extends AbstractBaseExt implements IPortCap {

	public PortCapContextExt(PortCapContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PortCapContext getContext() {
		return (PortCapContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).portCap());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PortCapContext) {
				addToContexts(ctx);

			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PortCapContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected void getSemanticInfo(HashMap<String, String> propStore) {
		PortCapContext ctx = getContext();
		if (ctx != null && ctx.children != null && ctx.children.size() > 0) {
			if (!propStore.containsKey("portCap")) {
				propStore.put("portCap", ctx.extendedContext.getFormattedText());
			} else {
				throw new IllegalStateException("PortCap" + " is duplicated in " + propStore.get("propName")
						+ "in line " + ctx.start.getLine());
			}
		}
	}
	
	@Override
	public String  getPortCap() {
		PortCapContext ctx = getContext();
		return ctx.extendedContext.getFormattedText().replace("port_cap", "");
	}
}
