package com.forge.parser.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.parser.PopulateExtendedContextVisitor;
import com.forge.parser.gen.ForgeParser.PortCap_wContext;

public class PortCap_wContextExt extends AbstractBaseExt {

	public PortCap_wContextExt(PortCap_wContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public PortCap_wContext getContext() {
		return (PortCap_wContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).portCap_w());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof PortCap_wContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + PortCap_wContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}

	@Override
	protected Integer writePortValue() {
		PortCap_wContext ctx = getContext();
		return Integer.parseInt(ctx.NUM().getText());
	}
}
