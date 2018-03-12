package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.PortCap_rContext;

public class PortCap_rContextExt extends AbstractBaseExt {

	public PortCap_rContextExt(PortCap_rContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PortCap_rContext getContext() {
		return (PortCap_rContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).portCap_r());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PortCap_rContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PortCap_rContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected Integer readPortValue() {
		PortCap_rContext ctx = getContext();
		return Integer.parseInt(ctx.NUM().getText());
	}
}
